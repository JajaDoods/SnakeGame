module SnakeUI
  require 'ruby2d'

  # Score - methods for controlling the score label 
  class Score
    attr_reader :score

    def initialize(x: 10, y: 10, grid_size: 25, **kwargs)
      @x, @y = x, y
      @grid_size = grid_size

      @score = kwargs[:score] || 0
      @color = kwargs[:color] || 'white'

      @hide = false
    end

    def draw
      Text.new("Score #{@score}", x: @x, y: @y, size: @grid_size, color: @color) unless @hide
    end

    def increase(score)
      @score += score
    end

    def decrease(score)
      @score.minu score
    end

    def reset
      @score = 0
    end

    def hide
      @hide = true
    end
  end
end