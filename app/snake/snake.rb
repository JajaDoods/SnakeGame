module SnakeGame
  require 'ruby2d'
  require 'set'

  DIRECTIONS = %w[up down left right].freeze
  OPPOSITE_DIRECTIONS = [%w[up down], %w[left right]].freeze

  # This error occurs if points that forming
  # snake body are too far away
  class BodyError < StandardError
    def initialize(msg = 'Invalid snake body points.')
      super msg
    end
  end

  # This error occures if new direction is unkown
  class UnkownDirectionError < StandardError
    def initialize(dir)
      super "Unkown direction: '#{dir}'."
    end
  end

  # This error occures if new direction invalid
  # after previos direction
  class ForbiddenDirectionError < StandardError
    def initialize(new_dir, snake_body)
      super "Direction '#{new_dir}' forbidden for #{snake_body}."
    end
  end

  # Snake - methods for controlling the snake
  class Snake
    attr_reader :direction, :body

    def initialize(*body, **kwargs)
      @body = body.empty? ? [[10, 10], [10, 11], [10, 12]] : body
      raise BodyError unless correct_body?

      new_direction(kwargs[:direction] || 'up')
      @head_color = kwargs[:head_color] || 'red'
      @body_color = kwargs[:body_color] || 'white'
      @grid_width = kwargs[:grid_width] || 20
    end

    def draw
      @body.each_with_index do |p, i|
        color = i.zero? ? @head_color : @body_color
        Square.new(x: p[0] * @grid_width, y: p[1] * @grid_width, size: @grid_width, color: color)
      end
    end

    def direction=(dir)
      new_direction dir
    end

    protected

    def correct_body?
      return false if @body.size < 2

      @body.each_cons(2) do |p1, p2|
        return false unless [p1, p2].all?(Array) &&
                            [*p1, *p2].all?(Integer) &&
                            [p1.size, p2.size].all?(2)

        return false if cell_distance(p1, p2) != 1
      end
      true
    end

    def new_direction(dir)
      return if dir == @direction

      raise UnkownDirectionError unless DIRECTIONS.include? dir
      raise ForbiddenDirectionError.new(dir, @body) if opposite_directions?(dir, snake_direction)

      @direction = dir
    end

    def snake_direction
      if    snake_up?    then 'up'
      elsif snake_down?  then 'down'
      elsif snake_right? then 'right'
      elsif snake_left?  then 'left'
      else
        raise BodyError # cause snake body forming the direction
      end
    end

    def opposite_directions?(dir1, dir2)
      OPPOSITE_DIRECTIONS.each { |opp| return true if Set[*opp] == Set[dir1, dir2] }
      false
    end

    def snake_up?
      @body[0][0] == @body[1][0] && @body[0][1] < @body[1][1]
    end

    def snake_down?
      @body[0][0] == @body[1][0] && @body[0][1] > @body[1][1]
    end

    def snake_left?
      @body[0][1] == @body[1][1] && @body[0][0] < @body[1][0]
    end

    def snake_right?
      @body[0][1] == @body[1][1] && @body[0][0] > @body[1][0]
    end

    def cell_distance(cell1, cell2)
      x1, y1 = cell1
      x2, y2 = cell2
      Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    end
  end
end
