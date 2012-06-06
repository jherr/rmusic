require 'rmusic'

describe Rmusic::Shape do
  it "should make chords" do
    g = Rmusic::StringedInstrument.guitar()

    Rmusic::ChordFinder.find( g, 'Asus4' ).each { |c|
      print "#{c.notation} #{c.count} #{c.playability}\n"
    }
  end
end
