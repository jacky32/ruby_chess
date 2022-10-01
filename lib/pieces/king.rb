# frozen_string_literal: false

require_relative '../piece'
require_relative '../movement'

# class for the king pieces
class King < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color:, piece_position:)
    super
    assign_visual("\u265A")
  end

  def optional_move_checks_passed?(_start_coordinate, _end_coordinate)
    # TODO: move to game?
    # return false if possible_check?(coordinate: end_coordinate, board: board)

    true
  end

  def generate_all(board:)
    @possible_moves = generate_one_around(board: board)
    @possible_takes = @possible_moves
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all

  # TODO: control from game?
  # currently disabled due to board
  def possible_check?(coordinate:, board:)
    pieces = assign_pieces
    pieces.any? do |piece|
      piece.generate_possible_takes(board: board)
      takes = piece.possible_takes
      takes.any? do |take|
        take.id_y == coordinate[:id_y] && take.id_x == coordinate[:id_x]
      end
    end
  end

  # selects pieces of opposite color that exist on the board
  def assign_pieces
    ObjectSpace.each_object(BoardPiece).to_a.map(&:content).reject do |piece|
      piece.nil? || piece.piece_color == @piece_color
    end
  end
end
