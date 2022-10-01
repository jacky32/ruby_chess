# rubocop:disable all

require './lib/game'
require 'pry-byebug'


module PawnSpecHelper
  def create_coordinate(id_y, id_x)
    {
      id_x: id_x,
      id_y: id_y,
      tile: @board.board[id_y][id_x],
      value: @board[id_y, id_x]
    }
  end

  def create_piece(board:, id_y:, id_x:, type:, color:)
    board.board[id_y][id_x].generate_piece(type, color, { id_y: id_y, id_x: id_x})
  end
end

describe Pawn do
  include PawnSpecHelper
  describe '#decide_piece_move' do
    context 'white pawn' do
      context 'starting in b2' do
        before(:each) do
          @game = Game.new
          @board = @game.board
          @start_id_y = 7
          @start_id_x = 2
          @pawn = create_piece(board: @board, id_y: @start_id_y, id_x: @start_id_x, type: 'pawn', color: 'white')
          @start_coordinate = create_coordinate(@start_id_y, @start_id_x)
        end

        it 'moves to b3 (1 in front)' do
          end_id_y = 6
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).to be(@pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it "moves to b4 (2 in front)" do
          end_id_y = 5
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).to be(@pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it "doesn't move to b1 (1 back)" do
          end_id_y = 8
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).not_to be(@pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't move to a2 (1 to the left)" do
          end_id_y = 7
          end_id_x = 1
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).not_to be(@pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't move to c2 (1 to the right)" do
          end_id_y = 7
          end_id_x = 3
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).not_to be(@pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "moves to b3 (1 in front) but doesn't move to b5 (2 in front) afterwards" do
          end_id_y = 6
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]
          expect(ending_tile).to be(@pawn)
          expect(starting_tile).not_to be(@pawn)

          final_id_y = 4
          final_id_x = 2
          final_coordinate = create_coordinate(final_id_y, final_id_x)
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(end_coordinate, final_coordinate)
          expect(@board[final_id_y, final_id_x]).not_to be(@pawn)
          expect(@board[end_id_y, end_id_x]).to be(@pawn)
        end

        it 'takes black pawn at c3' do
          enemy_id_y = 6
          enemy_id_x = 3
          black_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'black')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).to be(@pawn)
          expect(enemy_tile).not_to be(black_pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it 'takes black pawn at a3' do
          enemy_id_y = 6
          enemy_id_x = 1
          black_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'black')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).to be(@pawn)
          expect(enemy_tile).not_to be(black_pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it "doesn't take black pawn at e7" do
          enemy_id_y = 2
          enemy_id_x = 5
          black_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'black')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).not_to be(@pawn)
          expect(enemy_tile).to be(black_pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't take black pawn at b3" do
          enemy_id_y = 6
          enemy_id_x = 2
          black_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'black')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).not_to be(@pawn)
          expect(enemy_tile).to be(black_pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't take white pawn at a3" do
          enemy_id_y = 6
          enemy_id_x = 1
          white_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'white')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).not_to be(@pawn)
          expect(enemy_tile).to be(white_pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't take white pawn at b3" do
          enemy_id_y = 6
          enemy_id_x = 2
          white_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'white')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).not_to be(@pawn)
          expect(enemy_tile).to be(white_pawn)
          expect(starting_tile).to be(@pawn)
        end
      end
    end
    context 'black pawn' do
      context 'starting in b7' do
        before(:each) do
          @game = Game.new
          @board = @game.board
          @start_id_y = 2
          @start_id_x = 2
          @pawn = create_piece(board: @board, id_y: @start_id_y, id_x: @start_id_x, type: 'pawn', color: 'black')
          @start_coordinate = create_coordinate(@start_id_y, @start_id_x)
        end

        it 'moves to b6 (1 in front)' do
          end_id_y = 3
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).to be(@pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it "moves to b5 (2 in front)" do
          end_id_y = 4
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).to be(@pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it "doesn't move to b8 (1 back)" do
          end_id_y = 1
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).not_to be(@pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't move to a7 (1 to the left)" do
          end_id_y = 2
          end_id_x = 1
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).not_to be(@pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't move to c7 (1 to the right)" do
          end_id_y = 2
          end_id_x = 3
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(ending_tile).not_to be(@pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "moves to b6 (1 in front) but doesn't move to b4 (2 in front) afterwards" do
          end_id_y = 3
          end_id_x = 2
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(@start_coordinate, end_coordinate)

          ending_tile = @board[end_id_y, end_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]
          expect(ending_tile).to be(@pawn)
          expect(starting_tile).not_to be(@pawn)

          final_id_y = 5
          final_id_x = 2
          final_coordinate = create_coordinate(final_id_y, final_id_x)
          end_coordinate = create_coordinate(end_id_y, end_id_x)

          @game.decide_piece_move(end_coordinate, final_coordinate)
          expect(@board[final_id_y, final_id_x]).not_to be(@pawn)
          expect(@board[end_id_y, end_id_x]).to be(@pawn)
        end

        it 'takes white pawn at c6' do
          enemy_id_y = 3
          enemy_id_x = 3
          white_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'white')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).to be(@pawn)
          expect(enemy_tile).not_to be(white_pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it 'takes white pawn at a6' do
          enemy_id_y = 3
          enemy_id_x = 1
          white_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'white')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).to be(@pawn)
          expect(enemy_tile).not_to be(white_pawn)
          expect(starting_tile).not_to be(@pawn)
        end

        it "doesn't take white pawn at e7" do
          enemy_id_y = 2
          enemy_id_x = 5
          white_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'white')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).not_to be(@pawn)
          expect(enemy_tile).to be(white_pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't take white pawn at b6" do
          enemy_id_y = 3
          enemy_id_x = 2
          white_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'white')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).not_to be(@pawn)
          expect(enemy_tile).to be(white_pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't take black pawn at a6" do
          enemy_id_y = 3
          enemy_id_x = 1
          black_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'black')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).not_to be(@pawn)
          expect(enemy_tile).to be(black_pawn)
          expect(starting_tile).to be(@pawn)
        end

        it "doesn't take black pawn at b6" do
          enemy_id_y = 3
          enemy_id_x = 2
          black_pawn = create_piece(board: @board, id_y: enemy_id_y, id_x: enemy_id_x, type: 'pawn', color: 'black')

          enemy_coordinate = create_coordinate(enemy_id_y, enemy_id_x)

          @game.decide_piece_move(@start_coordinate, enemy_coordinate)

          enemy_tile = @board[enemy_id_y, enemy_id_x]
          starting_tile = @board[@start_id_y, @start_id_x]

          expect(enemy_tile).not_to be(@pawn)
          expect(enemy_tile).to be(black_pawn)
          expect(starting_tile).to be(@pawn)
        end
      end
    end
  end
end