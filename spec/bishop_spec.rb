# rubocop:disable all

require './lib/board'
require './spec/piece_spec_helper'


describe Bishop do
  include PieceSpecHelper
  let(:board) { Board.new }
  describe '#generate_all' do
    context 'white bishop' do
      context 'starting in b1' do
        before do
          id_y = 8
          id_x = 2
          @bishop = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'bishop', color: 'white')
        end
        it 'generates all possible moves and takes' do
          expect(@bishop.possible_moves).to be_empty
          
          @bishop.generate_all(board: board)
          expect(@bishop.possible_moves).to contain_exactly(board[7, 1], board[7, 3], board[6, 4], board[5, 5], board[4, 6], board[3, 7], board[2, 8])
          expect(@bishop.possible_takes).to contain_exactly(board[7, 1], board[7, 3], board[6, 4], board[5, 5], board[4, 6], board[3, 7], board[2, 8])
        end
      end
    end
  end
  context 'black bishop' do
    context 'starting in b1' do
      before do
        id_y = 8
        id_x = 2
        @bishop = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'bishop', color: 'black')
      end
      it 'generates all possible moves and takes' do
        expect(@bishop.possible_moves).to be_empty
        
        @bishop.generate_all(board: board)
        expect(@bishop.possible_moves).to contain_exactly(board[7, 1], board[7, 3], board[6, 4], board[5, 5], board[4, 6], board[3, 7], board[2, 8])
        expect(@bishop.possible_takes).to contain_exactly(board[7, 1], board[7, 3], board[6, 4], board[5, 5], board[4, 6], board[3, 7], board[2, 8])
      end
    end
  end
end