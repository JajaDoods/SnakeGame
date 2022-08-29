module SnakeGame
  require 'ruby2d'
  require 'set'

  # directions basic info
  DIRECTIONS = %w[up down left right].freeze
  OPPOSITE_DIRECTIONS = [%w[up down], %w[left right]].freeze

  # Snake - methods for controlling the snake
  class Snake
    def initialize(body = [[10, 10], [10, 11], [10, 12]], direction = 'up', **kwargs)
      @body = body.squeeze
      @direction  = direction

      @head_color = kwargs['hcolor'] || kwargs['head_color'] || 'red'
      @body_color = kwargs['bcolor'] || kwargs['body_color'] || 'white'
      @grid_width = kwargs['gwidth'].to_i || kwargs['grid_width'].to_i || 20
    end
  end
end
