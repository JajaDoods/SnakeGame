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
    end

    def draw
      Text.new("Score #{@score}", x: @x, y: @y, size: @grid_size, color: @color)
    end

    def increase(score)
      @score += score
    end

    def decrease(score)
      @score -= score
    end

    def reset
      @score = 0
    end
  end
end