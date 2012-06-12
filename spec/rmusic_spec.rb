require 'rmusic'

describe Rmusic::Shape do
  it "should make chords" do
    g = Rmusic::StringedInstrument.guitar()

    cs = Rmusic::ChordSequence.new()
    cs.push( Rmusic::ChordCache.find( g, 'Asus4' ) )
    cs.push( Rmusic::ChordCache.find( g, 'Cmin' ) )
    cs.push( Rmusic::ChordCache.find( g, 'D#' ) )
    cs.push( Rmusic::ChordCache.find( g, 'E' ) )
    
    cs.reorder( Rmusic::ChordOrderStrategy.easy )
    
    cs.sequence.each { |cl|
      c = cl.chords[0]
      print "#{c.notation} #{c.inversion} #{c.playability} #{c.extras} #{c.median}\n"
    }

#    cs.sequence[0].chords.each { |c|
#     print "#{c.notation} #{c.inversion} #{c.playability} #{c.extras} #{c.median}\n"
#    }

#    Rmusic::ChordFinder.find( g, 'A' ).chords.each { |c|
#       print "#{c.notation} #{c.inversion} #{c.playability} #{c.extras} #{c.median}\n"
#    }
  end

    it "should handle capos" do
      g = Rmusic::StringedInstrument.guitar()

      cs = Rmusic::ChordSequence.new()
      cs.push( Rmusic::ChordCache.find( g, 'Asus4' ) )
      cs.push( Rmusic::ChordCache.find( g, 'Cmin' ) )
      cs.push( Rmusic::ChordCache.find( g, 'D#' ) )
      cs.push( Rmusic::ChordCache.find( g, 'E' ) )
      
      cs.capo( 6 )

      cs.reorder( Rmusic::ChordOrderStrategy.open )

      cs.sequence.each { |cl|
        c = cl.chords[0]
        print "#{c.notation} #{c.playability} #{c.median}\n"
      }
    end
end
