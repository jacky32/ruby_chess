require './lib/board'

describe Board do
  subject(:board) { described_class.new }
  describe '#populate' do
    it 'populates the board with pieces' do
      expect(board[7, 2].content).to be_nil

      board.populate
      expect(board[7, 2].content).not_to be_nil
      expect(board[6, 2].content).to be_nil
    end
  end

  describe '#show_board' do
    it 'prints the board' do
      expect do
        board.show_board
      end.to output.to_stdout
    end
  end

  describe '#[]' do
    it 'does access the empty board piece' do
      expect(board[7, 2].content).to be_nil
    end

    it 'does access the filled board piece' do
      board.populate
      expect(board[7, 2].content).not_to be_nil
    end
  end
end
