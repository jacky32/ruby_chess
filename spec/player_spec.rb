require './lib/player'

describe Player do
  context '#name_valid?' do
    let(:player) { described_class.new('white', 'name') }
    it 'returns false when invalid' do
      name = 'This name is too long to be valid'
      expect(player.name_valid?(name)).to be_falsey
    end

    it 'returns true when valid' do
      name = 'Valid name'
      expect(player.name_valid?(name)).to be_truthy
    end
  end

  context '#name_loop' do
    it 'returns name when given valid name' do
      player = described_class.new('white')
      allow(player).to receive(:gets).and_return('test name')
      expect(player.name_loop).to eq('test name')
    end
  end
end
