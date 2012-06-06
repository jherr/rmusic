module Rmusic

  class Shape
    EASY = 1
    MEDIUM = 5
    HARD = 10
    
    BAR_CHORD = 1
    CLASSIC = 2
  
    attr_reader :locations
    def initialize( shape, difficulty = Shape::HARD, extra = 0 )
      lmin = shape.select { |n| n != - 1 }.min
      @locations = shape.map { |n| n - lmin }
      @difficulty = difficulty
      @extra = extra
    end
    def compare( other )
      diff = @difficulty
      other.locations.each_index { |string|
        d2 = ( @locations[ string ] - other.locations[ string ] ).abs
        diff += d2 * d2
      }
      diff
    end
  end

  class KnownShapes
    SHAPES = [
      Shape.new( [0,0,0,0,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,0,2,2,2,0], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [0,4,-1,2,5,0], Shape::HARD ),
      Shape.new( [0,2,2,1,0,0], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,0,2,2,2,0], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,0,3,-1,-1,1], Shape::EASY ),
      Shape.new( [-1,0,3,2,2,1], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,0,-1,2,2,1], Shape::HARD ),
      Shape.new( [-1,0,2,1,2,0], Shape::MEDIUM ),
      Shape.new( [0,0,2,4,2,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,0,7,6,0,0], Shape::EASY ),
      Shape.new( [-1,0,0,2,2,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,2,2,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,6,5,5], Shape::EASY ),
      Shape.new( [-1,-1,0,9,10,9], Shape::EASY ),
      Shape.new( [3,-1,2,2,2,0], Shape::HARD ),
      Shape.new( [-1,0,2,0,2,0], Shape::EASY ),
      Shape.new( [-1,0,2,2,2,3], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,0,2,2,2,2], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [0,-1,4,2,2,0], Shape::MEDIUM ),
      Shape.new( [2,-1,2,2,2,0, Shape::HARD] ),
      Shape.new( [-1,0,4,2,2,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,0,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,2,2,-1,-1,0], Shape::MEDIUM ),
      Shape.new( [-1,0,2,2,-1,0], Shape::MEDIUM ),
      Shape.new( [5,7,7,-1,-1,0], Shape::MEDIUM ),
      Shape.new( [0,0,2,0,2,2], Shape::HARD ),
      Shape.new( [5,5,4,0,3,0], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,0,2,0,3,2], Shape::MEDIUM ),
      Shape.new( [1,0,3,0,2,1], Shape::HARD ),
      Shape.new( [-1,0,0,0,2,0], Shape::EASY ),
      Shape.new( [-1,0,2,0,3,0], Shape::MEDIUM ),
      Shape.new( [-1,0,2,0,3,3], Shape::MEDIUM ),
      Shape.new( [-1,0,2,2,3,3], Shape::MEDIUM ),
      Shape.new( [5,-1,0,0,3,0], Shape::HARD ),
      Shape.new( [-1,0,0,0,-1,0], Shape::HARD ),
      Shape.new( [-1,-1,0,2,2,1], Shape::MEDIUM ),
      Shape.new( [-1,3,2,1,1,0], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,-1,0,1,0,3], Shape::MEDIUM ),
      Shape.new( [-1,0,2,0,1,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,0,0,1], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,1,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,2,0,1,0,0], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [0,2,2,1,3,0], Shape::MEDIUM, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,2,0,1,3,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,4,4,4], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,2,0,1,0,1], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,1,0,1], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,2,0,0,0], Shape::EASY ),
      Shape.new( [0,2,1,1,0,0], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [0,-1,6,4,4,0], Shape::HARD ),
      Shape.new( [-1,-1,1,1,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,2,2,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,3,-1,2,4,0], Shape::HARD ),
      Shape.new( [-1,-1,0,2,1,2], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,1,0,2], Shape::MEDIUM ),
      Shape.new( [-1,0,2,2,1,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,0,7,5,5,5], Shape::MEDIUM ),
      Shape.new( [-1,3,2,2,1,0], Shape::EASY ),
      Shape.new( [8,12,-1,-1,-1,0], Shape::HARD ),
      Shape.new( [0,0,7,5,0,0], Shape::MEDIUM ),
      Shape.new( [-1,3,2,2,0,0], Shape::EASY ),
      Shape.new( [-1,-1,0,2,1,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,5,5,5], Shape::EASY ),
      Shape.new( [0,0,3,2,1,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [1,3,3,2,1,0], Shape::HARD ),
      Shape.new( [1,-1,2,2,1,0], Shape::HARD ),
      Shape.new( [-1,-1,3,2,1,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,0,2,0,1,3], Shape::MEDIUM ),
      Shape.new( [-1,0,2,2,1,3], Shape::MEDIUM ),
      Shape.new( [-1,0,5,5,5,8], Shape::HARD ),
      Shape.new( [-1,0,2,2,1,2], Shape::MEDIUM ),
      Shape.new( [-1,-1,1,1,0,1], Shape::HARD ),
      Shape.new( [-1,5,7,5,8,0], Shape::MEDIUM ),
      Shape.new( [-1,0,6,5,5,7], Shape::MEDIUM ),
      Shape.new( [0,0,2,2,3,0], Shape::MEDIUM, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,0,2,2,3,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [5,5,7,7,-1,0], Shape::HARD ),
      Shape.new( [-1,0,0,2,3,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [0,0,2,2,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,0,2,4,0,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [0,2,2,2,0,0], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,0,2,2,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,0,2,1,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,2,0,2,0,0], Shape::MEDIUM ),
      Shape.new( [-1,2,0,2,3,0], Shape::MEDIUM ),
      Shape.new( [-1,2,1,2,0,0], Shape::MEDIUM ),
      Shape.new( [0,0,3,2,0,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [3,-1,2,2,0,0], Shape::HARD ),
      Shape.new( [-1,0,2,0,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,0,5,4,5,0], Shape::MEDIUM ),
      Shape.new( [-1,0,4,4,0,0], Shape::EASY ),
      Shape.new( [4,-1,0,2,3,0], Shape::HARD ),
      Shape.new( [0,1,-1,2,3,0], Shape::HARD ),
      Shape.new( [-1,-1,7,7,6,0], Shape::EASY ),
      Shape.new( [0,0,0,2,3,2], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [0,0,4,2,3,0], Shape::MEDIUM ),
      Shape.new( [2,-1,0,2,3,0], Shape::HARD ),
      Shape.new( [-1,0,2,2,3,2], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,0,1,0], Shape::EASY ),
      Shape.new( [-1,5,4,2,3,0], Shape::MEDIUM ),
      Shape.new( [-1,9,7,7,-1,0], Shape::HARD ),
      Shape.new( [3,2,1,0,0,3], Shape::MEDIUM ),
      Shape.new( [3,-1,1,0,0,3], Shape::HARD ),
      Shape.new( [2,-1,1,2,0,2], Shape::HARD ),
      Shape.new( [-1,0,1,2,0,2], Shape::MEDIUM ),
      Shape.new( [-1,2,1,2,0,2], Shape::HARD ),
      Shape.new( [-1,-1,4,4,4,0], Shape::EASY ),
      Shape.new( [0,0,4,4,4,0], Shape::EASY, Shape::CLASSIC ),
      Shape.new( [0,2,1,2,0,2], Shape::MEDIUM ),
      Shape.new( [3,-1,1,0,0,0], Shape::HARD ),
      Shape.new( [-1,-1,1,0,0,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,3,3,1], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,3,3,2], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,3,-1,0], Shape::HARD ),
      Shape.new( [0,0,2,1,2,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,6,6,6], Shape::EASY ),
      Shape.new( [-1,1,3,3,3,0], Shape::MEDIUM ),
      Shape.new( [0,2,0,0,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,0,2,2,-1,5], Shape::HARD ),
      Shape.new( [-1,0,0,0,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [2,-1,4,3,3,0], Shape::HARD ),
      Shape.new( [-1,3,-1,3,2,0], Shape::HARD ),
      Shape.new( [-1,-1,0,3,2,0], Shape::MEDIUM ),
      Shape.new( [-1,1,2,0,2,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,4,3,2,0], Shape::EASY ),
      Shape.new( [0,0,2,2,1,0], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,0,0,0,0,2], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,1,2,1,2,0], Shape::MEDIUM ),
      Shape.new( [-1,2,0,2,0,1], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,2,0,1], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [1,-1,0,0,0,3], Shape::MEDIUM ),
      Shape.new( [3,2,0,0,0,1], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,4,3,2], Shape::MEDIUM ),
      Shape.new( [-1,0,4,4,3,2], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [-1,2,0,2,0,2], Shape::HARD ),
      Shape.new( [-1,2,0,2,3,2], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,2,0,2], Shape::MEDIUM ),
      Shape.new( [2,2,0,0,0,3], Shape::MEDIUM ),
      Shape.new( [2,2,0,0,3,3], Shape::MEDIUM ),
      Shape.new( [3,2,0,0,0,2], Shape::MEDIUM ),
      Shape.new( [0,0,2,4,3,2], Shape::MEDIUM ),
      Shape.new( [0,2,0,2,0,2], Shape::HARD ),
      Shape.new( [-1,0,1,1,2,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [7,9,9,-1,-1,0], Shape::HARD ),
      Shape.new( [-1,2,4,4,-1,0], Shape::HARD ),
      Shape.new( [-1,2,2,2,-1,0], Shape::HARD ),
      Shape.new( [-1,4,4,4,-1,0], Shape::HARD ),
      Shape.new( [0,2,2,1,0,2], Shape::MEDIUM ),
      Shape.new( [0,-1,4,1,0,0], Shape::HARD ),
      Shape.new( [2,2,2,1,0,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [0,2,2,0,0,2], Shape::MEDIUM ),
      Shape.new( [0,2,4,0,0,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [0,-1,4,0,0,0], Shape::HARD ),
      Shape.new( [2,2,2,0,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,3,2,0,1,0], Shape::MEDIUM ),
      Shape.new( [0,3,5,5,5,3], Shape::MEDIUM ),
      Shape.new( [3,3,2,0,1,0], Shape::EASY ),
      Shape.new( [3,-1,2,0,1,0], Shape::HARD ),
      Shape.new( [-1,3,2,0,1,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,3,5,5,5,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,4,5,-1,0], Shape::HARD ),
      Shape.new( [0,3,2,0,0,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [-1,2,2,0,1,0], Shape::MEDIUM ),
      Shape.new( [3,-1,0,0,1,0], Shape::HARD ),
      Shape.new( [-1,3,0,0,1,0], Shape::MEDIUM ),
      Shape.new( [-1,3,2,0,3,0], Shape::MEDIUM ),
      Shape.new( [-1,3,2,0,3,3], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,5,5,3], Shape::MEDIUM ),
      Shape.new( [-1,10,12,12,13,0], Shape::MEDIUM ),
      Shape.new( [-1,5,5,5,-1,0], Shape::HARD ),
      Shape.new( [-1,3,3,0,1,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,3,0,1,0], Shape::MEDIUM ),
      Shape.new( [0,3,-1,3,3,2], Shape::HARD ),
      Shape.new( [-1,3,2,3,2,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,2,2,1,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,3,0,0,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,3,3,0,1,1], Shape::MEDIUM ),
      Shape.new( [-1,-1,3,0,1,1], Shape::MEDIUM ),
      Shape.new( [-1,7,9,9,10,0], Shape::MEDIUM ),
      Shape.new( [-1,3,0,0,3,3], Shape::MEDIUM ),
      Shape.new( [-1,2,4,2,5,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,2,1,3], Shape::MEDIUM ),
      Shape.new( [3,3,0,0,0,3], Shape::MEDIUM ),
      Shape.new( [-1,3,0,0,0,3], Shape::MEDIUM ),
      Shape.new( [3,3,0,0,1,1], Shape::MEDIUM ),
      Shape.new( [2,-1,2,1,0,0], Shape::HARD, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,2,1,0,2], Shape::MEDIUM ),
      Shape.new( [-1,3,3,0,0,3], Shape::MEDIUM ),
      Shape.new( [-1,7,5,5,-1,0], Shape::HARD ),
      Shape.new( [2,0,0,2,3,2], Shape::MEDIUM ),
      Shape.new( [-1,0,0,2,3,2], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,0,4,2,3,2], Shape::HARD ),
      Shape.new( [-1,-1,0,2,3,2], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,-1,0,7,7,5], Shape::MEDIUM ),
      Shape.new( [-1,3,5,3,5,0], Shape::MEDIUM ),
      Shape.new( [-1,0,0,2,1,2], Shape::MEDIUM ),
      Shape.new( [-1,1,-1,0,1,0], Shape::HARD ),
      Shape.new( [-1,-1,0,14,14,14], Shape::EASY ),
      Shape.new( [-1,-1,0,2,2,2], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [5,-1,4,0,3,5], Shape::HARD ),
      Shape.new( [3,-1,0,2,3,2], Shape::HARD ),
      Shape.new( [0,0,2,2,-1,0], Shape::HARD ),
      Shape.new( [-1,0,0,2,3,5], Shape::MEDIUM ),
      Shape.new( [0,0,0,2,1,2], Shape::MEDIUM ),
      Shape.new( [2,-1,0,2,1,0], Shape::HARD ),
      Shape.new( [-1,5,7,5,7,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,2,0,1,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,2,2,2,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,3,0,2,1], Shape::MEDIUM ),
      Shape.new( [-1,4,3,4,0,4], Shape::HARD ),
      Shape.new( [0,2,2,0,2,0], Shape::MEDIUM ),
      Shape.new( [3,-1,0,0,2,0], Shape::HARD ),
      Shape.new( [-1,-1,0,0,2,0], Shape::EASY ),
      Shape.new( [-1,-1,2,1,2,0], Shape::MEDIUM ),
      Shape.new( [-1,4,6,6,-1,0], Shape::HARD ),
      Shape.new( [0,2,2,1,2,0], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,1,1,1], Shape::EASY ),
      Shape.new( [-1,0,0,2,3,1], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,2,1,1], Shape::EASY ),
      Shape.new( [-1,-1,0,5,6,5], Shape::MEDIUM ),
      Shape.new( [3,-1,0,2,1,1], Shape::HARD ),
      Shape.new( [5,-1,0,0,3,5], Shape::HARD ),
      Shape.new( [3,0,0,0,3,3], Shape::MEDIUM ),
      Shape.new( [-1,0,0,0,3,3], Shape::EASY ),
      Shape.new( [-1,-1,0,2,3,3], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,2,3,0], Shape::MEDIUM ),
      Shape.new( [3,0,0,0,0,3], Shape::MEDIUM ),
      Shape.new( [3,2,0,2,0,3], Shape::MEDIUM ),
      Shape.new( [-1,7,6,4,5,0], Shape::MEDIUM ),
      Shape.new( [0,0,3,4,3,4], Shape::MEDIUM ),
      Shape.new( [0,2,-1,-1,-1,0, Shape::HARD] ),
      Shape.new( [-1,7,9,9,-1,0], Shape::HARD ),
      Shape.new( [-1,0,0,1,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,1,3,1,3,1], Shape::MEDIUM ),
      Shape.new( [0,2,0,1,0,2], Shape::MEDIUM ),
      Shape.new( [2,2,0,1,0,0], Shape::MEDIUM, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [-1,-1,5,3,4,0], Shape::MEDIUM ),
      Shape.new( [3,-1,0,3,3,0], Shape::HARD ),
      Shape.new( [0,2,2,0,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [3,-1,2,0,0,0], Shape::HARD ),
      Shape.new( [-1,2,5,-1,-1,0], Shape::HARD ),
      Shape.new( [0,2,0,0,3,0], Shape::EASY ),
      Shape.new( [0,2,2,0,3,0], Shape::MEDIUM ),
      Shape.new( [0,2,2,0,3,3], Shape::MEDIUM ),
      Shape.new( [-1,-1,0,12,12,12], Shape::EASY ),
      Shape.new( [-1,-1,0,9,8,7], Shape::EASY ),
      Shape.new( [0,-1,0,0,0,0], Shape::HARD ),
      Shape.new( [-1,10,12,12,12,0], Shape::MEDIUM ),
      Shape.new( [0,0,0,0,0,3], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [3,-1,0,2,0,0], Shape::HARD ),
      Shape.new( [0,2,0,0,0,2], Shape::EASY ),
      Shape.new( [0,2,0,0,3,2], Shape::MEDIUM ),
      Shape.new( [2,2,0,0,0,0], Shape::EASY ),
      Shape.new( [0,2,1,1,0,2], Shape::MEDIUM ),
      Shape.new( [4,-1,4,4,4,0], Shape::HARD ),
      Shape.new( [0,6,4,0,0,0], Shape::EASY ),
      Shape.new( [-1,0,3,2,1,1], Shape::MEDIUM ),
      Shape.new( [-1,2,2,1,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,2,1,0,0], Shape::EASY ),
      Shape.new( [-1,7,9,-1,-1,0], Shape::HARD ),
      Shape.new( [-1,2,2,0,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,2,3,2,1,0], Shape::MEDIUM ),
      Shape.new( [1,3,3,2,0,0], Shape::MEDIUM ),
      Shape.new( [0,0,3,0,1,3], Shape::MEDIUM ),
      Shape.new( [3,2,0,0,0,3], Shape::EASY ),
      Shape.new( [3,2,0,0,3,3], Shape::MEDIUM ),
      Shape.new( [3,-1,0,0,0,3], Shape::HARD ),
      Shape.new( [-1,-1,0,4,3,3], Shape::EASY ),
      Shape.new( [-1,-1,0,7,8,7], Shape::MEDIUM ),
      Shape.new( [3,-1,0,0,3,3], Shape::HARD ),
      Shape.new( [-1,3,0,0,0,1], Shape::MEDIUM ),
      Shape.new( [-1,0,0,0,0,1], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,0,1,0,1,1], Shape::HARD ),
      Shape.new( [-1,0,4,3,2,0], Shape::MEDIUM, Shape::BAR_CHORD ),
      Shape.new( [-1,2,2,2,0,0], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [-1,-1,0,3,3,3], Shape::EASY, Shape::BAR_CHORD ),
      Shape.new( [0,0,3,3,3,3], Shape::EASY, Shape::BAR_CHORD | Shape::CLASSIC ),
      Shape.new( [5,0,0,0,3,0], Shape::EASY )
    ]
    def self.compare( shape )
      min = 50
      SHAPES.each { |s|
        c = s.compare( shape )
        min = c if ( c < min )
        break if ( min == 0 )
      }
      min
    end
  end

end
