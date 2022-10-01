# rubocop:disable all

require './lib/board'
require 'pry-byebug'
require './spec/piece_spec_helper'


describe Knight do
  include PieceSpecHelper
  let(:board) { Board.new }
  describe '#generate_all' do
    context 'white knight' do
      context 'starting in b1' do
        before(:each) do
          id_y = 8
          id_x = 2
          @knight = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'knight', color: 'white')
        end
        it 'generates all possible moves and takes' do
          expect(@knight.possible_moves).to be_empty
          
          @knight.generate_all(board: board.board)
          expect(@knight.possible_moves).to contain_exactly(board.board[6][1], board.board[6][3], board.board[7][4])
          expect(@knight.possible_takes).to contain_exactly(board.board[6][1], board.board[6][3], board.board[7][4])
        end
      end

      context 'starting in d4' do
        before(:each) do
          id_y = 5
          id_x = 4
          @knight = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'knight', color: 'white')
        end
        it 'generates all possible moves and takes' do
          expect(@knight.possible_moves).to be_empty
          
          @knight.generate_all(board: board.board)
          expect(@knight.possible_moves).to contain_exactly(board.board[3][3], board.board[3][5],
                                                            board.board[4][2], board.board[4][6],
                                                            board.board[6][2], board.board[6][6],
                                                            board.board[7][3], board.board[7][5])
          expect(@knight.possible_takes).to contain_exactly(board.board[3][3], board.board[3][5],
                                                            board.board[4][2], board.board[4][6],
                                                            board.board[6][2], board.board[6][6],
                                                            board.board[7][3], board.board[7][5])
        end
      end
    end
  end
end