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

  # This error occurs if food color not found in
  # Food.food_scores
  class UnkownFoodError < StandardError
    def initialize(msg = 'Unkown food color')
      super msg
    end
  end

  class InvalidFoodCostError < StandardError
    def initialize(msg = 'Invalid food cost')
      super msg
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
      @grid_size = kwargs[:grid_width] || 20

      @screen_width = kwargs[:screen_width] || 620
      @screen_height = kwargs[:screen_height] || 620
    end

    def draw
      body = @body.map { |c| crop_coords(c) }
      body.each_with_index do |p, i|
        color = i.zero? ? @head_color : @body_color
        Square.new(x: p[0] * @grid_size, y: p[1] * @grid_size, size: @grid_size, color: color)
      end
    end

    def direction=(dir)
      new_direction dir
    end

    def move
      @body.pop # remove snake tail
      case @direction
      when 'up'    then move_up
      when 'down'  then move_down
      when 'left'  then move_left
      when 'right' then move_right
      else
        raise UnkownDirectionError
      end
    end

    def eat_food?(food)
      body = @body.map { |c| crop_coords(c) }
      body.include? [food.x, food.y]
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

    def crop_coords(cell)
      grid_width = @screen_width / @grid_size
      grid_height = @screen_height / @grid_size

      [cell[0] % grid_width, cell[1] % grid_height]
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

    def move_up
      @body.unshift [@body[0][0], @body[0][1] - 1]
    end

    def move_down
      @body.unshift [@body[0][0], @body[0][1] + 1]
    end

    def move_left
      @body.unshift [@body[0][0] - 1, @body[0][1]]
    end

    def move_right
      @body.unshift [@body[0][0] + 1, @body[0][1]]
    end

    def cell_distance(cell1, cell2)
      x1, y1 = cell1
      x2, y2 = cell2
      Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
    end
  end

  # Food constains info about food and method for controlling
  class Food
    attr_reader :x, :y, :color

    class << self
      @@food_cost = {
        white: 1,
        blue: 5,
        red: 10,
        yellow: 15
      }

      def food
        @@food_cost
      end

      def [](color)
        color = color.to_sym unless color.is_a? Symbol
        raise UnkownFoodError unless Food.food.key? color

        @@food_cost[color]
      end

      def []=(color, cost)
        color = color.to_sym unless color.is_a? Symbol
        raise InvalidFoodCostError unless cost.is_a?(Integer) && cost.positive?

        @@food_cost[color] = cost
      end

      def delete(color)
        color = color.to_sym unless color.is_a? Symbol
        @@food_cost.delete color
      end
    end

    def initialize(screen_width: 620, screen_height: 620, grid_size: 20, **kwargs)
      @screen_width = screen_width
      @screen_height = screen_height
      @grid_size = grid_size

      new_food(color: kwargs[:color] || Food.food.keys.sample)
    end

    def draw
      Square.new(x: @x * @grid_size, y: @y * @grid_size, size: @grid_size, color: @color.to_s)
    end

    def new_food(color: nil)
      new_color(color || Food.food.keys.sample)
      @x = rand(@screen_width / @grid_size)
      @y = rand(@screen_height / @grid_size)
    end

    def color=(color)
      new_color(color)
    end

    def cost
      Food[@color]
    end

    protected

    def new_color(color)
      color = color.to_sym unless color.is_a? Symbol
      raise UnkownFoodError unless Food.food.key? color

      @color = color
    end
  end
end
