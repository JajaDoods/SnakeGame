module SnakeGame
  require 'ruby2d'
  require 'set'

  # directions basic info
  DIRECTIONS = %w[up down left right].freeze
  OPPOSITE_DIRECTIONS = [%w[up down], %w[left right]].freeze

  SnakeBodyError = Error.new 'Invalid snake body points.'

  # Snake - methods for controlling the snake
  class Snake
    def initialize(*body, **kwargs)
      @body = body.empty? ? [[10, 10], [10, 11], [10, 12]] : body
      raise SnakeBodyError unless correct_body?

      @direction  = kwargs['direction']  || 'up'
      @head_color = kwargs['head_color'] || 'red'
      @body_color = kwargs['body_color'] || 'white'
      @grid_width = kwargs['grid_width'] || 20
    end

    def draw
      @body.each_with_index do |p, i|
        color = i.zero? ? @head_color : @body_color
        Square.new(x: p[0] * @grid_width, y: p[1] * @grid_width, size: @grid_width, color: color)
      end
    end

    private

    def correct_body?
      return false if @body.size < 2

      @body.each_cons(2) do |p1, p2|
        return false unless [p1, p2].all?(Array) &&
                            [*p1, *p2].all?(Integer) &&
                            [p1.size, p2.size].all?(2)

        return false if Math.sqrt(((p2[0] - p1[0])**2) + ((p2[1] - p1[1])**2)) > 1
      end
      true
    end
  end
end
