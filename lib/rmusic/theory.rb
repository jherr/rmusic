module Rmusic
class Music
  IONIAN_SCALE = [ 2, 2, 1, 2, 2, 2, 1 ]
  SCALE_NOTES = [ 'C', 'C#',
                  'D', 'D#',
                  'E',
                  'F', 'F#',
                  'G', 'G#',
                  'A', 'A#',
                  'B' ]
end

class CircleOfFifths
  def self.instance
    @@instance
  end
  
  def [](note)
    @scales[note]
  end

  def initialize()
    @scales = []
    (0..12).each { |root|
      fnote = root
      @scales[ root ] = [ fnote ]
      (0..14).each { |ii|
        fnote += Music::IONIAN_SCALE[ ii % 7 ]
        @scales[ root ].push( fnote % 12 )
      }
    }
  end

  @@instance = CircleOfFifths.new()

  private_class_method :new
end

class Note
  def Note.name( note )
    Music::SCALE_NOTES[ note ]
  end
  def Note.by_name( name )
    Music::SCALE_NOTES.each_index { |n|
      return n if ( Music::SCALE_NOTES[n].downcase == name.downcase )
    }
    -1
  end
end

class MidiNote
  def MidiNote.toNote( mnote )
    mnote % 12
  end
end

class Scale
  attr_accessor :name
  attr_accessor :intervals
  def initialize( name, intervals )
    @name = name
    @intervals = intervals
  end
end

class ScaleLibrary
  SCALES = [
    Scale.new( 'Ionian (major)', 	[ 2, 2, 1, 2, 2, 2, 1 ] ),
  	Scale.new( 'Dorian', 			[ 2, 1, 2, 2, 2, 1, 2 ] ),
  	Scale.new( 'Phrygian', 			[ 1, 2, 2, 2, 1, 2, 2 ] ),
  	Scale.new( 'Lydian', 			[ 2, 2, 2, 1, 2, 2, 1 ] ),
  	Scale.new( 'Mixolydian', 		[ 2, 2, 1, 2, 2, 1, 2 ] ),
  	Scale.new( 'Aeolian', 			[ 2, 1, 2, 2, 1, 2, 2 ] ),
  	Scale.new( 'Locrian', 			[ 1, 2, 2, 1, 2, 2, 2 ] ),
  	Scale.new( 'Chromatic', 		[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ] ),
  	Scale.new( 'Adolfos Scale',		[ 1, 2, 2, 1, 1, 2, 2 ] ),
  	Scale.new( 'Diminished',		[ 2, 1, 2, 1, 2, 1, 2, 1 ] ),
  	Scale.new( 'Enigmatic',			[ 1, 3, 2, 2, 2, 1, 1 ] ),
  	Scale.new( 'Harmonic Minor',	[ 2, 1, 2, 2, 1, 3, 1 ] ),
  	Scale.new( 'Hungarian Minor',	[ 2, 1, 3, 1, 1, 3, 1 ] ),
  	Scale.new( 'Melodic Minor',		[ 2, 1, 2, 2, 2, 2, 1 ] ),
  	Scale.new( 'Neapolitan',		[ 1, 2, 2, 2, 2, 2, 1 ] ),
  	Scale.new( 'Neapolitan Minor',	[ 1, 2, 2, 2, 1, 3, 1 ] ),
  	Scale.new( 'Pentatonic',		[ 2, 2, 3, 2, 3 ] ),
  	Scale.new( 'Pentatonic Minor',	[ 3, 2, 2, 3, 2 ] ),
  	Scale.new( 'Ten Tone',			[ 1, 2, 1, 1, 1, 1, 2, 1, 1 ] ),
  	Scale.new( 'Whole Tone',		[ 2, 2, 2, 2, 2, 2 ] )
  ]
end

class Tone
  attr_accessor :root
  attr_accessor :augment
  def initialize( root, augment )
    @root = root
    @augment = augment
  end
  def Tone.parse( text )
    found = text.scan( /^(\d+)(.*)$/ )
    augment = 0
    augment = 1 if ( found[0][1] == '#' )
    augment = 2 if ( found[0][1] == '##' )
    augment = -1 if ( found[0][1] == 'b' )
    augment = -2 if ( found[0][1] == 'bb' )
    Tone.new( found[0][0].to_i, augment )
  end
end

class ChordSpelling
  attr_accessor :name
  attr_accessor :short_name
  attr_accessor :tones
  def initialize( name, short_name, tone_text )
    @name = name
    @short_name = short_name
    @tones = []
    tone_text.split( /,/ ).each { |tt|
      @tones.push( Tone.parse( tt ) )
    }
  end
  def note( root, tone )
    fnote = CircleOfFifths.instance[ root ][ tone.root - 1 ] + tone.augment
    ( fnote + 12 ) % 12
  end
  def notes( root )
    @tones.map { |t|
      note( root, t )
    }
  end
end

class ChordLibrary
  CHORDS = [
		ChordSpelling.new( "Maj.", ',maj', "1,3,5" ),
		ChordSpelling.new( "11th", '11', "1,3,5,7b,9,11" ),
		ChordSpelling.new( "11th-9", nil, "1,3,5,7b,9b,11" ), 
		ChordSpelling.new( "13th", '13', "1,3,5,7b,9,11,13" ), 
		ChordSpelling.new( "13th no 5th", nil, "1,3,7b,9,11,13" ),
		ChordSpelling.new( "6th", '6', "1,3,5,6" ),
		ChordSpelling.new( "6th-7", nil, "1,3,5,6,7b" ),
		ChordSpelling.new( "6th-7 Sus.", nil, "1,4,5,6,7b" ),
		ChordSpelling.new( "7th", '7', "1,3,5,7b" ),
		ChordSpelling.new( "7th-9+5", nil, "1,3,5#,7b,9b" ),
		ChordSpelling.new( "7th+11", '7+11', "1,3,5,7b,9,11#" ),
		ChordSpelling.new( "7th+5", "7+5", "1,3,5#,7b" ),
		ChordSpelling.new( "7th+9", '7+9', "1,3,5,7b,9#" ),
		ChordSpelling.new( "7th+9+5", nil, "1,3,5#,7b,9#" ),
		ChordSpelling.new( "7th+9-5", nil, "1,3,5b,7b,9#" ),
		ChordSpelling.new( "7th-5", '7-5', "1,3,5b,7b" ),
		ChordSpelling.new( "7th-9", '7-9', "1,3,5,7b,9b" ),
		ChordSpelling.new( "7th-9-5", nil, "1,3,5b,7b,9b" ),
		ChordSpelling.new( "7th Sus. 4", '7sus4', "1,4,5,7b" ),
		ChordSpelling.new( "7th-11", nil, "1,3,5,7b,11" ),
		ChordSpelling.new( "9th", '9', "1,3,5,7b,9" ),
		ChordSpelling.new( "9th+5", '9+5', "1,3,5#,7b,9" ),
		ChordSpelling.new( "9th-5", '9-5', "1,3,5b,7b,9" ),
		ChordSpelling.new( "Add +11", nil, "1,3,5,11#" ),
		ChordSpelling.new( "Add 9", 'add9', "1,3,5,9" ),
		ChordSpelling.new( "Aug.", 'aug', "1,3,5#" ),
		ChordSpelling.new( "Dim.", 'dim', "1,3b,5b" ),
		ChordSpelling.new( "Dim. 7th", 'dim7,7dim', "1,3b,5b,7bb" ),
		ChordSpelling.new( "Maj. 6 add 9", nil, "1,3,5,6,9" ),
		ChordSpelling.new( "Maj. 7th", 'maj7,7maj', "1,3,5,7" ),
		ChordSpelling.new( "Maj. 7th+11", nil, "1,3,5,7,11#" ),
		ChordSpelling.new( "Maj. 7th+5", nil, "1,3,5#,7" ),
		ChordSpelling.new( "Maj. 7th-5", nil, "1,3,5b,7" ),
		ChordSpelling.new( "Maj. 9th", 'maj9,9maj', "1,3,5,7,9" ),
		ChordSpelling.new( "Maj. 9th+11", nil, "1,3,5,7,9,11#" ),
		ChordSpelling.new( "Maj.-Min. 7th", nil, "1,3b,5,7" ),
		ChordSpelling.new( "Min.", 'm,min', "1,3b,5" ),
		ChordSpelling.new( "Min. 11th", 'maj11', "1,3b,5,7b,9,11" ),
		ChordSpelling.new( "Min. 6th", 'maj6', "1,3b,5,6" ),
		ChordSpelling.new( "Min. 6th Add 9", nil, "1,3b,5,6,9" ),
		ChordSpelling.new( "Min. 6th-7", nil, "1,3b,5,6,7b" ),
		ChordSpelling.new( "Min. 6th-7-11", nil, "1,3b,5,6,7b,11" ),
		ChordSpelling.new( "Min. 7th", 'maj7', "1,3b,5,7b" ),
		ChordSpelling.new( "Min. 7th-5", nil, "1,3b,5b,7b" ),
		ChordSpelling.new( "Min. 7th-9", nil, "1,3b,5,7b,9b" ),
		ChordSpelling.new( "Min. 7th-11", nil, "1,3b,5,7b,11" ),
		ChordSpelling.new( "Min. 9th", 'maj9', "1,3b,5,7b,9" ),
		ChordSpelling.new( "Min. 9th-5", nil, "1,3b,5b,7b,9" ),
		ChordSpelling.new( "Min. Add 9", 'min+9', "1,3b,5,9" ),
		ChordSpelling.new( "Min.-Maj. 9th", nil, "1,3b,5,7,9" ),
		ChordSpelling.new( "Sus. 4", 'sus4', "1,4,5" )
	]
	
	def self.by_name( name )
	  CHORDS.each { |cs|
	    return cs if ( cs.name == name )
	  }
	  nil
  end
	
	def self.by_short_name( name )
	  CHORDS.each { |cs|
	    next unless ( cs.short_name )
	    cs.short_name.split( /,/ ).each { |css|
  	    return cs if ( css.downcase == name.downcase )
	    }
	  }
	  nil
  end
  
  def self.parse_short_name( name )
    found = name.strip.scan(/([A-Z](?:[b#])?)(.*?)$/i)
    if ( found[0][0] =~ /[A-Z]b/i )
      root = found[0][0].scan(/([A-Z])/)
      note = ( Note.by_name( root[0][0] ) + 11 ) % 12
    else
      note = Note.by_name( found[0][0] )
    end
    sname = found[0][1]
    { :root => note, :chord => ChordLibrary.by_short_name( sname ) }
  end
end
end
