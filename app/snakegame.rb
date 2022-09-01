require 'ruby2d'
require_relative 'snake/snake'
require_relative 'snake/score'

set background: 'navy'
set title: 'Snake Game', width: 620, height: 620
set fps_cap: 20



snake = SnakeGame::Snake.new
food = SnakeGame::Food.new
score = SnakeUI::Score.new

update do
  clear

  food.draw
  snake.draw
  score.draw

  snake.move unless snake.eat_self?
  if snake.eat_food? food
    score.increase(food.cost)
    snake.grow
    food.new_food
  end
  if snake.eat_self?  
    score.hide
    Text.new("You'r score was: #{score.score}. Press 'R' to restart.", x: 20, y: 320)
  end
end

on :key_down do |event|
  if SnakeGame::DIRECTIONS.include? event.key
    snake.direction = event.key
  elsif event.key.downcase == 'r'
    snake = SnakeGame::Snake.new
    food = SnakeGame::Food.new
    score = SnakeUI::Score.new
  end
rescue => err
  puts err
end

show