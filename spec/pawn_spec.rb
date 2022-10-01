# rubocop:disable all

require './lib/game'
require 'pry-byebug'


module PawnSpecHelper
  def create_coordinate(id_y, id_x)
    {
      id_x: id_x,
      id_y: id_y,
      tile: @board[id_y][id_x],
      value: @board[id_y][id_x].content
    }
  end
end

describe Pawn do
  include PawnSpecHelper
  describe '#decide_piece_move' do
    context 'white pawn' do
      context 'starting in b2' do
        before(:each) do
          @game = Game.new
          @board = @game.board.board
          @bb = @game.board
          @start_id_y = 7
          @start_id_x = 2
          @pawn = @board[@start_id_y][@start_id_x].generate_piece('pawn', 'white', { 'id_y': @start_id_y, 'id_x': @start_id_x })
          @start_coordinate = create_coordinate(@start_id_y, @start_id_x)
        end

        it 'moves to b3 (1 in front)' do
          end_id_y = 6
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y][end_id_x].content
          starting_tile = @board[@start_id_y][@start_id_x].content

          expect(ending_tile).to be(@pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it "moves to b4 (2 in front)" do
          end_id_y = 5
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y][end_id_x].content
          starting_tile = @board[@start_id_y][@start_id_x].content

          expect(ending_tile).to be(@pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it "doesn't move to b1 (1 back)" do
          end_id_y = 8
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y][end_id_x].content
          starting_tile = @board[@start_id_y][@start_id_x].content

          expect(ending_tile).not_to be(@pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't move to a2 (1 to the left)" do
          end_id_y = 7
          end_id_x = 1
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y][end_id_x].content
          starting_tile = @board[@start_id_y][@start_id_x].content

          expect(ending_tile).not_to be(@pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't move to c2 (1 to the right)" do
          end_id_y = 7
          end_id_x = 3
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y][end_id_x].content
          starting_tile = @board[@start_id_y][@start_id_x].content

          expect(ending_tile).not_to be(@pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "moves to b3 (1 in front) but doesn't move to b5 (2 in front) afterwards" do
          end_id_y = 6
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y][end_id_x].content
          starting_tile = @board[@start_id_y][@start_id_x].content
          expect(ending_tile).to be(@pawn)
          expect(starting_tile).not_to be(@pawn)

          final_id_y = 4
          final_id_x = 2
          final_coordinate = create_coordinate(final_id_y, final_id_x)
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(end_coordinate, final_coordinate)
          expect(@board[final_id_y][final_id_x].content).not_to be(@pawn)
          expect(@board[end_id_y][end_id_x].content).to be(@pawn)
        end
      end
    end
  end
end