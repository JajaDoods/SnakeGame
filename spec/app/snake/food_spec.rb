RSpec.describe SnakeGame::Food do
  it 'Checking Food color intialization assigment' do
    expect { SnakeGame::Food.new color: 'white'}.not_to raise_error
    expect { SnakeGame::Food.new color: :white}.not_to raise_error
    
    expect { SnakeGame::Food.new color: 'blue'}.not_to raise_error
    expect { SnakeGame::Food.new color: :blue}.not_to raise_error

    expect { SnakeGame::Food.new color: 'red'}.not_to raise_error
    expect { SnakeGame::Food.new color: :red}.not_to raise_error

    expect { SnakeGame::Food.new color: 'yellow'}.not_to raise_error
    expect { SnakeGame::Food.new color: :yellow}.not_to raise_error

    expect { SnakeGame::Food.new color: 'brown'}.to raise_error(SnakeGame::UnkownFoodError)
    expect { SnakeGame::Food.new color: :brown}.to raise_error(SnakeGame::UnkownFoodError)
    expect { SnakeGame::Food.new color: 'yelloW'}.to raise_error(SnakeGame::UnkownFoodError)
    expect { SnakeGame::Food.new color: :yelloW}.to raise_error(SnakeGame::UnkownFoodError)
  end

  it 'Checking Food.[] method' do
    expect{ SnakeGame::Food['white'] }.not_to raise_error
    expect{ SnakeGame::Food[:white] }.not_to raise_error

    expect{ SnakeGame::Food['blue'] }.not_to raise_error
    expect{ SnakeGame::Food[:blue] }.not_to raise_error

    expect{ SnakeGame::Food['red'] }.not_to raise_error
    expect{ SnakeGame::Food[:red] }.not_to raise_error

    expect{ SnakeGame::Food['yellow'] }.not_to raise_error
    expect{ SnakeGame::Food[:yellow] }.not_to raise_error

    expect{ SnakeGame::Food['color'] }.to raise_error(SnakeGame::UnkownFoodError)
    expect{ SnakeGame::Food[:color] }.to raise_error(SnakeGame::UnkownFoodError)
    expect{ SnakeGame::Food['yelloW'] }.to raise_error(SnakeGame::UnkownFoodError)
    expect{ SnakeGame::Food[:yelloW] }.to raise_error(SnakeGame::UnkownFoodError)
  end

  it 'Checking Food.[]= method' do
    expect{ SnakeGame::Food['my_color'] = 12 }.not_to raise_error

    expect{ SnakeGame::Food['my_color'] = 0 }.to raise_error(SnakeGame::InvalidFoodCostError)
    expect{ SnakeGame::Food['my_color'] = -1 }.to raise_error(SnakeGame::InvalidFoodCostError)

    expect{ SnakeGame::Food['my_color'] = '1' }.to raise_error(SnakeGame::InvalidFoodCostError)
    expect{ SnakeGame::Food['my_color'] = 1.1 }.to raise_error(SnakeGame::InvalidFoodCostError)

    SnakeGame::Food.delete 'my_color'
  end

  it 'Checking Food.food method' do
    expect(SnakeGame::Food.food).to eq({ white: 1, blue: 5, red: 10, yellow: 15 })

    SnakeGame::Food['brown'] = 10
    expect(SnakeGame::Food.food).to eq({ white: 1, blue: 5, red: 10, yellow: 15, brown: 10 })

    SnakeGame::Food.delete :brown
  end

  it 'Checking Food.delete method' do
    SnakeGame::Food.delete 'white'
    expect(SnakeGame::Food.food).to eq({ blue: 5, red: 10, yellow: 15 })

    SnakeGame::Food.delete :blue
    expect(SnakeGame::Food.food).to eq({ red: 10, yellow: 15 })

    SnakeGame::Food['white'] = 1
    SnakeGame::Food['blue'] = 5
  end

  it 'Checking Food#cost method' do
    food = SnakeGame::Food.new color: 'white'
    expect(food.cost).to eq(1)

    food.color = :blue
    expect(food.cost).to eq(5)

    food.color = 'red'
    expect(food.cost).to eq(10)

    food.color = 'yellow'
    expect(food.cost).to eq(15)
  end
end