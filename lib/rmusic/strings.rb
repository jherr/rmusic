module Rmusic

  class StringedInstrumentLocation
    attr_accessor :fret
    attr_accessor :string
    def initialize( string, fret )
      @string = string
      @fret = fret
    end
  end

  class StringedInstrument
    GUITAR_BASE_NOTE = 40
    BASS_BAS_NOTE = 28
    STANDARD_FRET_COUNT = 22
  
    def initialize( startNote, numFrets, tuning )
  		@startNote = startNote
  		@numFrets = numFrets
  		@tuningName = ''
  		self.tuning=tuning if ( tuning != nil )
    end
  
    def self.bass()
      StringedInstrument.new( BASS_BAS_NOTE, STANDARD_FRET_COUNT, TuningLibrary.by_name( 'Bass Standard' ) )
    end
  
    def self.guitar()
      StringedInstrument.new( GUITAR_BASE_NOTE, STANDARD_FRET_COUNT, TuningLibrary.by_name( 'Guitar Standard' ) )
    end
  
    def find_note( note )
      out = []
      @midiTuning.each_index { |string|
        startNote = @midiTuning[string] % 12
        fret = note - startNote
        while( fret < @numFrets )
          out.push( StringedInstrumentLocation.new( string, fret ) ) if ( fret >= 0 )
          fret += 12
        end
      }
      out
    end
  
    def numStrings
      @tuning.length
    end
  
    def top_notes()
      @midiTuning
    end
  
    def tuning()
      @tuning
    end
  
    def top_names()
      @tuning.map { |n| Note.name( n ) }
    end
  
    def tuning=( tuning )
  		@tuning = []
  		@midiTuning = []
  		@tuningName = tuning.name
  		midiNoteValue = @startNote
  		nString = 0
  		tuning.intervals.each { |ti|
  			midiNoteValue += ti
  			@midiTuning.push( midiNoteValue )
  			@tuning.push(  MidiNote.toNote( midiNoteValue ) )
  		}
    end
  
    def noteAt( string, fret )
      ( fret != -1 ) ? @midiTuning[ string ] + fret : -1
    end
  end

  class Tuning
    attr_accessor :name
    attr_accessor :intervals
    def initialize( name, intervals )
      @name = name
      @intervals = intervals
    end
  end

  class TuningLibrary
    TUNINGS = [
      Tuning.new( 'Guitar Standard', [  0, 5, 5, 5, 4, 5 ] ),
  		Tuning.new( 'D Modal', [ -2, 7, 5, 5, 2, 5 ] ),
  		Tuning.new( 'Dropped D', [ -2, 7, 5, 5, 4, 5 ] ),
  		Tuning.new( 'Dropped D & A', [ -2, 7, 5, 5, 2, 7 ] ),
  		Tuning.new( 'Dropped semi-tone', [ -1, 5, 5, 5, 4, 5 ] ),
  		Tuning.new( 'Dropped whole-tone', [ -2, 5, 5, 5, 4, 5 ] ),
  		Tuning.new( 'G Modal', [ -2, 5, 7, 5, 5, 2 ] ),
  		Tuning.new( 'Open C', [ -4, 7, 5, 7, 5, 4 ] ),
  		Tuning.new( 'Open C II', [  0, 3, 5, 4, 8, 7 ] ),
  		Tuning.new( 'Open D', [ -2, 7, 5, 4, 3, 5 ] ),
  		Tuning.new( 'Open D Minor', [ -2, 7, 5, 3, 4, 5 ] ),
  		Tuning.new( 'Open E', [  0, 7, 5, 4, 3, 5 ] ),
  		Tuning.new( 'Open E Minor', [  0, 7, 5, 3, 4, 5 ] ),
  		Tuning.new( 'Open Eb', [ -1, 5, 5, 5, 4, 5 ] ),
  		Tuning.new( 'Open G', [ -2, 5, 7, 5, 4, 3 ] ),
  		Tuning.new( 'Bass Standard', [  0, 5, 5, 5 ] ) ]
  	def self.by_name( name )
  	  TUNINGS.each { |t|
  	    return t if ( t.name == name )
  	  }
  	  nil
    end
  	def self.by_string_count( count )
  	  TUNINGS.select { |t|
  	    ( t.intervals.length == count )
  	  }
    end
  end

  class StringedChord
    attr_reader :notes
    attr_reader :inversion
  
    def initialize( instrument, notes = nil )
      @instrument = instrument
  		@notes = (0..instrument.numStrings-1).map { -1 }
  		notes.each_index { |string|
  		  @notes[ string ] = notes[ string ]
  		} if ( notes != nil )
  		@inversion = -1

  		@playability = nil
  		@min = nil
  		@max = nil
    end

    def compare( other )
      diff = 0
      other.notes.each_index { |string|
        diff += ( @notes[ string ] - other.notes[ string ] ).abs
      }
      diff
    end
  
    def to_shape()
      Shape.new( @notes )
    end
  
    def playability()
      @playability = KnownShapes.compare( self.to_shape ) if ( @playability == nil )
      @playability
    end
  
    def contains( other )
      @notes.each_index { |string|
        if ( @notes[ string ] == -1 )
          return false if ( other.notes[ string ] != -1 )
        elsif ( other.notes[ string ] == -1 )
        else
          return false if ( @notes[ string ] != other.notes[ string ] )
        end
      }
      true
    end
  
    def count()
      @notes.select { |n| n != -1 }.length
    end
  
    def min_fret()
  		@min = @notes.select { |n| n!=-1 }.min if ( @min == nil )
      @min
    end
  
    def max_fret()
  		@max = @notes.max if ( @max == nil )
      @max
    end
  
    def midi_notes
      out = []
      @notes.each_index { |string|
        out.push( @instrument.noteAt( string, @notes[string] ) )
      }
      out
    end

    def lowest_note()
      midi_notes.select { |mn| mn != -1 }.min
    end
  
    def set_note( string, fret )
      @notes[string] = fret
    
      @min = nil
      @max = nil
    end
  
    def has_note?( string )
      @notes[ string ] != -1
    end
  
    def contiguous()
      state = -1
      @notes.each_index { |string|
        if ( @notes[ string ] == -1 )
          state = 1 if ( state == 0 )
        else
          state = 0 if ( state == -1 )
          return false if ( state == 1 )
        end
      }
      true
    end
  
    def notation
      notes.map { |n|
        "%2d" % [ n ]
      }.join( ' ' )
    end
  
    def location_string
      self.midi_notes.map { |n|
        n
      }.join( ' ' )
    end
  
    def to_s
      self.midi_notes.map { |n|
        ( n != -1 ) ? ( '%02s' % Note.name( MidiNote.toNote( n ) ) ) : '  '
      }.join( ' ' )
    end
  
    def pretty
      out = "   #{@instrument.top_notes.map { |n| "%02s" % [ Note.name( n % 12 ) ] }.join(' ')}\n"
      ( min_fret .. max_fret ).each { |f|
        strings = []
        @notes.each_index { |string|
          strings.push( @notes[string] == f ? 'x' : '|' )
        }
        if ( f == min_fret )
          out += "%2d  %s\n" % [ f, strings.join('  ') ]
        else
          out += "    %s\n" % [ strings.join('  ') ]
        end
      }
      out
    end
  end

  class ChordFinder
    attr_reader :chords
  
    def self.find( instrument, short_name, options = {} )
      cinfo = ChordLibrary.parse_short_name( short_name )
      ChordFinder.new( instrument, cinfo[:chord], cinfo[:root], options ).chords
    end

    def initialize( instrument, spelling, root, options = {} )
      @chords = nil

      @distance = 4
      @distance = options[:distance] if ( options.has_key? :distance )

      add_chords( instrument, spelling.notes( root ), false )
    
      unless ( options.has_key? :doubling && options[ :doubling ] == false )
        add_chords( instrument, spelling.notes( root ), true )
        add_chords( instrument, spelling.notes( root ), true )
      end

      dups = {}
      @chords = @chords.select { |c|
        good = ( dups.has_key?( c.location_string ) == false )
        dups[c.location_string] = true
        good 
      }
    
      @chords.each { |c| dups[c.location_string] = true }

      @chords.sort! { |a,b|
         ( a.count <=> b.count ) * -1
      }

      super_chords = []
      @chords.each { |c|
        found = false
        super_chords.each { |sc|
          if ( sc.contains( c ) )
            found = true
            break
          end
        }
        super_chords.push( c ) unless( found )
      }
      @chords = super_chords
    
      @chords.sort! { |a,b|
        diff = a.playability <=> b.playability
        diff = a.min_fret <=> b.min_fret if ( diff == 0 )
        diff
      }
    end

    def add_chords( instrument, notes, doubling )
      notes.each { |n|
        if ( @chords == nil )
          @chords = []
          instrument.find_note( n ).each { |loc|
            chord = StringedChord.new( instrument )
            chord.set_note( loc.string, loc.fret )
            @chords.push( chord )
          }
        else
          note_locs = instrument.find_note( n )
          out_chords = []
          @chords.each { |c|
            out_chords.push( c ) if ( doubling )
            note_locs.each { |loc|
              unless ( c.has_note?( loc.string ) )
                chord = StringedChord.new( instrument, c.notes )
                chord.set_note( loc.string, loc.fret )
                out_chords.push( chord ) if ( chord.max_fret - chord.min_fret <= @distance )
              end
            }
          }
          @chords = out_chords
        end
      }
    end
  end

end