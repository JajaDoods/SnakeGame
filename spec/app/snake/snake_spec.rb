RSpec.describe SnakeGame::Snake do

  it 'Checking Snake initialization' do
    expect { SnakeGame::Snake.new([1, 1], [1, 2], [1, 4]) }.to raise_error(SnakeGame::BodyError)
    expect { SnakeGame::Snake.new(1, 2, 3) }.to raise_error(SnakeGame::BodyError)
    expect { SnakeGame::Snake.new([1, 2, 3]) }.to raise_error(SnakeGame::BodyError)
    expect { SnakeGame::Snake.new([1, 2], [1, 2, 3]) }.to raise_error(SnakeGame::BodyError)
    expect { SnakeGame::Snake.new(%w[1 1], %w[1 2], %w[1 4]) }.to raise_error(SnakeGame::BodyError)
    expect { SnakeGame::Snake.new([1, 1, 1], %w[1 2], %w[1 4]) }.to raise_error(SnakeGame::BodyError)
  end

  it 'Checkign Snake direction assigment' do
    # 'up' direction testing
    snake_up = SnakeGame::Snake.new(direction: 'up')
    expect{ SnakeGame::Snake.new(direction: 'up') }.not_to raise_error # test initialization
    expect{ snake_up.direction = 'up' }.not_to raise_error
    expect{ snake_up.direction = 'left' }.not_to raise_error
    expect{ snake_up.direction = 'right' }.not_to raise_error
    expect{ snake_up.direction = 'down' }.to raise_error(SnakeGame::ForbiddenDirectionError)

    # 'down' direction testing
    snake_down = SnakeGame::Snake.new([4, 6], [4, 5], [4, 4], direction: 'down')
    expect{ snake_down.direction = 'down' }.not_to raise_error # test initialization
    expect{ snake_down.direction = 'left' }.not_to raise_error
    expect{ snake_down.direction = 'right' }.not_to raise_error
    expect{ snake_down.direction = 'up' }.to raise_error(SnakeGame::ForbiddenDirectionError)

    # 'left' direction testing
    snake_left = SnakeGame::Snake.new([1, 2], [2, 2], direction: 'left')
    expect{ snake_left.direction = 'left' }.not_to raise_error # test initialization
    expect{ snake_left.direction = 'up' }.not_to raise_error
    expect{ snake_left.direction = 'down' }.not_to raise_error
    expect{ snake_left.direction = 'right' }.to raise_error(SnakeGame::ForbiddenDirectionError)

    # 'right' direction testing
    snake_right = SnakeGame::Snake.new([4, 4], [3, 4], direction: 'right')
    expect{ SnakeGame::Snake.new([4, 4], [3, 4], direction: 'right') }.not_to raise_error # test initialization
    expect{ snake_right.direction = 'up' }.not_to raise_error
    expect{ snake_right.direction = 'down' }.not_to raise_error
    expect{ snake_right.direction = 'left' }.to raise_error(SnakeGame::ForbiddenDirectionError)
  end

  it 'Checking snake "move" method' do
    # direction = 'up'; body = [10, 10], [10, 11], [10, 12]
    snake = SnakeGame::Snake.new
    expect(snake.body).to eq([[10, 10], [10, 11], [10, 12]])

    snake.direction = 'left'
    snake.move
    expect(snake.body).to eq([[9, 10], [10, 10], [10, 11]])

    snake.direction = 'down'
    snake.move
    expect(snake.body).to eq([[9, 11], [9, 10], [10, 10]])

    snake.direction = 'right'
    snake.move
    expect(snake.body).to eq([[10, 11], [9, 11], [9, 10]])

    snake.direction = 'up'
    snake.move
    expect(snake.body).to eq([[10, 10], [10, 11], [9, 11]])
  end
end