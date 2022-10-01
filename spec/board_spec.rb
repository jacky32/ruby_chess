require './lib/board'

describe Board do
  describe '#populate' do
    it 'populates the board with pieces' do
      board = Board.new

      expect(board[7, 2]).to be_nil

      board.populate
      expect(board[7, 2]).not_to be_nil
    end
  end
end
