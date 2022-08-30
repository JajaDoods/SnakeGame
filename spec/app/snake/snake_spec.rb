RSpec.describe SnakeGame::Snake do

  it 'Checking Snake initialization' do
    expect { SnakeGame::Snake.new([1, 1], [1, 2], [1, 4]) }.to raise_error(SnakeGame::SnakeBodyError)
    expect { SnakeGame::Snake.new(1, 2, 3) }.to raise_error(SnakeGame::SnakeBodyError)
    expect { SnakeGame::Snake.new([1, 2, 3]) }.to raise_error(SnakeGame::SnakeBodyError)
    expect { SnakeGame::Snake.new([1, 2], [1, 2, 3]) }.to raise_error(SnakeGame::SnakeBodyError)
    expect { SnakeGame::Snake.new(%w[1 1], %w[1 2], %w[1 4]) }.to raise_error(SnakeGame::SnakeBodyError)
    expect { SnakeGame::Snake.new([1, 1, 1], %w[1 2], %w[1 4]) }.to raise_error(SnakeGame::SnakeBodyError)
  end

end