# rubocop:disable all

require './lib/board'
require 'pry-byebug'
require './spec/piece_spec_helper'


describe Pawn do
  include PieceSpecHelper
  describe '#generate_possible_moves' do
    let(:board) { Board.new }
    context 'white pawn' do
      context 'starting in b1' do
        before do
          id_y = 8
          id_x = 2
          @pawn = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'pawn', color: 'white')
        end
        it 'generates all possible moves' do
          expect(@pawn.possible_moves).to be_empty
          
          @pawn.generate_possible_moves(board: board)
          expect(@pawn.possible_moves).to contain_exactly(board[7, 2], board[6, 2])
        end
      end
      context 'starting in b1 with piece moves history' do
        before do
          id_y = 7
          id_x = 2
          @pawn = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'pawn', color: 'white')
          @pawn.piece_moves << [8, 2]
        end
        it 'generates all possible moves' do
          expect(@pawn.possible_moves).to be_empty
          
          @pawn.generate_possible_moves(board: board)
          expect(@pawn.possible_moves).to contain_exactly(board[6, 2])
        end
      end
    end
    context 'black pawn' do
      context 'starting in b8' do
        before do
          id_y = 1
          id_x = 2
          @pawn = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'pawn', color: 'black')
        end
        it 'generates all possible moves' do
          expect(@pawn.possible_moves).to be_empty
          
          @pawn.generate_possible_moves(board: board)
          expect(@pawn.possible_moves).to contain_exactly(board[2, 2], board[3, 2])
        end
      end
      context 'starting in b8 with piece moves history' do
        before do
          id_y = 2
          id_x = 2
          @pawn = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'pawn', color: 'black')
          @pawn.piece_moves << [1, 2]
        end
        it 'generates all possible moves' do
          expect(@pawn.possible_moves).to be_empty
          
          @pawn.generate_possible_moves(board: board)
          expect(@pawn.possible_moves).to contain_exactly(board[3, 2])
        end
      end
    end
  end
  describe '#generate_possible_takes' do
    let(:board) { Board.new }
    context 'white pawn' do
      context 'starting in b1' do
        before do
          id_y = 8
          id_x = 2
          @pawn = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'pawn', color: 'white')
        end
        it 'generates all possible takes' do
          @pawn.generate_possible_takes(board: board)
          expect(@pawn.possible_takes).to contain_exactly(board[7, 1], board[7, 3])
        end
      end
    end
    context 'black pawn' do
      context 'starting in b1' do
        before do
          id_y = 1
          id_x = 2
          @pawn = create_piece(board: board, id_y: id_y, id_x: id_x, type: 'pawn', color: 'black')
        end
        it 'generates all possible takes' do
          @pawn.generate_possible_takes(board: board)
          expect(@pawn.possible_takes).to contain_exactly(board[2, 1], board[2, 3])
        end
      end
    end
  end
end