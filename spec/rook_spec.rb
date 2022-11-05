# rubocop:disable all

require './lib/board'
require './spec/piece_spec_helper'


describe Rook do
  include PieceSpecHelper
  let(:board) { Board.new }
  describe '#generate_all' do
    context 'white rook' do
      context 'starting in b1' do
        before(:each) do
          id_y = 8
          id_x = 2
          @rook = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'rook', color: 'white')
        end
        it 'generates all possible moves and takes' do
          expect(@rook.possible_moves).to be_empty
          
          @rook.generate_all(board: board)
          expect(@rook.possible_moves).to contain_exactly(board[8, 1], board[8, 3],board[8, 4], board[8, 5],board[8, 6],board[8, 7],board[8, 8], board[1, 2], board[2, 2], board[3, 2], board[4, 2], board[5, 2], board[6, 2], board[7, 2])
          expect(@rook.possible_takes).to contain_exactly(board[8, 1], board[8, 3],board[8, 4], board[8, 5],board[8, 6],board[8, 7],board[8, 8], board[1, 2], board[2, 2], board[3, 2], board[4, 2], board[5, 2], board[6, 2], board[7, 2])
        end
      end
    end
  end
  context 'black rook' do
    context 'starting in b1' do
      before(:each) do
        id_y = 8
        id_x = 2
        @rook = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'rook', color: 'black')
      end
      it 'generates all possible moves and takes' do
        expect(@rook.possible_moves).to be_empty
        
        @rook.generate_all(board: board)
        expect(@rook.possible_moves).to contain_exactly(board[8, 1], board[8, 3],board[8, 4], board[8, 5],board[8, 6],board[8, 7],board[8, 8], board[1, 2], board[2, 2], board[3, 2], board[4, 2], board[5, 2], board[6, 2], board[7, 2])
        expect(@rook.possible_takes).to contain_exactly(board[8, 1], board[8, 3],board[8, 4], board[8, 5],board[8, 6],board[8, 7],board[8, 8], board[1, 2], board[2, 2], board[3, 2], board[4, 2], board[5, 2], board[6, 2], board[7, 2])
      end
    end
  end
end