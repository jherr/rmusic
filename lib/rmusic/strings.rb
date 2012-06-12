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
    
    attr_reader :startNote
    attr_reader :numFrets
  
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
  
    attr_reader :playability
    attr_accessor :extras
    attr_accessor :inversion
    
    def self.from_data( instrument, data )
      StringedChord.new( instrument, nil, data )
    end
  
    def initialize( instrument, notes = nil, data = nil )
      @instrument = instrument
  		@notes = (0..instrument.numStrings-1).map { -1 }
  		notes.each_index { |string|
  		  @notes[ string ] = notes[ string ]
  		} if ( notes != nil )
  		@inversion = -1

  		@playability = nil
  		@min = nil
  		@max = nil
  		@median = nil
  		@extras = 0
  		@capo = 0
  		
  		if ( data != nil )
        @playability = data[:playability]
        @min = data[:min]
        @max = data[:max]
        @inversion = data[:inversion]
        @notes = data[:notes]
        @extras = data[:extras]
		  end
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
      if ( @playability == nil )
        info = KnownShapes.compare( self.to_shape )
        @playability = info[:min]
        @extras = info[:extras]
      end
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
    
    # A chord is open when it can be played 6 or fewer frets from the capo
    def is_open?()
      ( max_fret - @capo <= 6 )
    end
    
    # A chord has open strings when it's open and has notes at the capo
    def has_open?()
      ( min_fret == @capo && max_fret - @capo <= 6 )
    end
    
    def classic?()
      ( @extras & Shape::CLASSIC ) > 0 
    end
    
    def bar_chord?()
      ( @extras & Shape::BAR_CHORD ) > 0 
    end
  
    def count()
      @notes.select { |n| n != -1 }.length
    end
    
    def capo( fret )
      @capo = fret
      ( fret <= min_fret )
    end
  
    def min_fret()
  		@min = @notes.select { |n| n!=-1 }.min if ( @min == nil )
      @min
    end
    
    def median()
      if ( @median == nil )
        mn = 0
        c = 0
        @notes.each { |n|
          next if ( n == -1 )
          mn += n
          c += 1
        }
        @median = ( c > 0 ) ? mn.to_f / c.to_f : 0
      end
      @median
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
      ( midi_notes.select { |mn| mn != -1 }.min ) % 12
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
      ChordList.new( instrument, cinfo[:chord], cinfo[:root], 
        ChordFinder.new( instrument, cinfo[:chord], cinfo[:root], options ).chords )
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
      
      inversion_map = spelling.inversions( root )
      @chords.each { |c|
        c.inversion = inversion_map[ c.lowest_note ]
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

  class ChordCache
    @@location = 'cache'
    
    def self.find( instrument, short_name, options = {} )
      cinfo = ChordLibrary.parse_short_name( short_name )
      self.find_chord( instrument, cinfo[:chord], cinfo[:root], options )
    end
    
    def self.find_chord( instrument, chord, root, options = {} )
      cname = self.build_cache_name( instrument, chord, root )
      Dir.mkdir( @@location ) unless ( Dir.exists? @@location )
      chords = []
      if ( File.exists?( "#{@@location}/#{cname}" ) )
        File.open( "#{@@location}/#{cname}" ).each { |cdata|
          chords.push( self.from_cache( instrument, cdata ) )
        }
      else
        chords = ChordFinder.new( instrument, chord, root, options ).chords
        File.open( "#{@@location}/#{cname}", 'w' ) { |fh|
          chords.each { |c|
            fh.print( self.to_cache( c ) + "\n" )
          }
        }
      end
      ChordList.new( instrument, chord, root, chords )
    end
    
    def self.build_cache_name( instrument, chord, root )
      cname = "#{instrument.startNote}_#{instrument.numFrets}_#{instrument.tuning.join('_')}_#{chord.name}_#{root}"
      cname.downcase.gsub( /\s/, '_' ).gsub( /[:.]/, '_' )
    end
    
    def self.to_cache( chord )
      "#{chord.notes.join(',')}:#{chord.inversion}:#{chord.playability}:#{chord.min_fret}:#{chord.max_fret}:#{chord.extras}:#{chord.median}"
    end
    
    def self.from_cache( instrument, cdata )
      elems = cdata.split( /:/ )
      data = {
        :notes => elems[0].split(/,/).map { |c| c.to_i },
        :inversion => elems[1].to_i,
        :playability => elems[2].to_f,
        :min => elems[3].to_i,
        :max => elems[3].to_i,
        :extras => elems[4].to_i,
        :median => elems[5].to_f
      }
      StringedChord.from_data( instrument, data )
    end
  end

  class ChordList
    attr_reader :chords
    attr_reader :instrument
    attr_reader :chord
    attr_reader :root
    
    def initialize( instrument, chord, root, chords = [] ) 
      @instrument = instrument
      @chord = chord
      @root = root
      @chords = chords
    end
    
    def push( chord )
      @chords.push( chord )
    end
    
    def capo( fret )
      @chords = @chords.select { |c| c.capo( fret ) }
    end

    def reorder( prev, strategy )
      weighted_chords = []
      @chords.each { |c|
        weighted_chords.push( { :weight => strategy.weight( prev, c ), :chord => c } )
      }
      weighted_chords.sort! { |a,b| a[:weight] <=> b[:weight] }
      @chords = []
      weighted_chords.each { |c|
        @chords.push( c[:chord] )
      }
    end
  end
  
  class ChordSequence
    attr_reader :sequence

    def initialize()
      @sequence = []
    end

    def push( cl )
      @sequence.push( cl )
    end

    def capo( fret )
      @sequence.each { |cl|
        cl.capo( fret )
      }
    end
    
    def reorder( strategy )
      last = nil
      @sequence.each { |cs|
        cs.reorder( last, strategy )
        last = cs.chords[0]
      }
    end
  end
  
  class ChordOrderStrategy
    attr_accessor :distance
    attr_accessor :open
    attr_accessor :difficulty
    attr_accessor :bar
    attr_accessor :classic
    attr_accessor :note_count
    
    def self.fat()
      strat = ChordOrderStrategy.new()
      strat.note_count = 2000
      strat
    end
    
    def self.open()
      strat = ChordOrderStrategy.new()
      strat.open = 5000
      strat.note_count = 1000
      strat
    end
    
    def self.easy()
      strat = ChordOrderStrategy.new()
      strat.difficulty = 500
      strat
    end
    
    def self.bar_chords()
      strat = ChordOrderStrategy.new()
      strat.bar = 5000
      strat
    end
    
    def self.classic()
      strat = ChordOrderStrategy.new()
      strat.classic = 5000
      strat
    end
    
    def self.boxed()
      strat = ChordOrderStrategy.new()
      strat.distance = 1000
      strat
    end
   
    def initialize()
      @distance = 10
      @open = 0
      @difficulty = 10
      @bar = 10
      @classic = 10
      @note_count = 0
    end
    
    def weight( a, b )
      am = ( a != nil ) ? a.median : 0
      bm = ( b != nil ) ? b.median : 0
      weight = 10000
      
      weight -= ( am - bm ).abs * @distance
      
      open = 0
      open += 1 if ( b.is_open? )
      open += 10 if ( b.has_open? )
      weight -= open * @open

      weight -= ( 50 - b.playability ) * @difficulty

      weight -= ( ( b.classic? == true ) ? 1 : 0 ) * @classic

      weight -= ( ( b.bar_chord? == true ) ? 1 : 0 ) * @bar

      weight -= b.count * @note_count

      weight
    end
  end

end