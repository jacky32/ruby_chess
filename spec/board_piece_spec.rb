# rubocop:disable all
require './lib/board'

describe BoardPiece do
  let(:board) { Board.new }
  subject(:board_piece) { board.board[7][2] }
  describe '#generate_piece' do
    it 'changes content from nil to the generated piece' do
      expect(board_piece.content).to be_nil

      board_piece.generate_piece('pawn', 'white', { id_y: 7, id_x: 2 })

      expect(board_piece.content).not_to be_nil
    end
  end

  describe '#remove_piece' do
    it 'removes the piece from the board_piece' do
      board_piece.generate_piece('pawn', 'white', { id_y: 7, id_x: 2 })
      expect(board_piece.content).not_to be_nil

      board_piece.remove_piece
      expect(board_piece.content).to be_nil
    end
  end

  describe '#empty?' do
    it 'returns true when empty' do
      expect(board_piece.empty?).to be_truthy
    end

    it 'returns false when not empty' do
      board_piece.generate_piece('pawn', 'white', { id_y: 7, id_x: 2 })
      expect(board_piece.empty?).to be_falsey
    end
  end
end
