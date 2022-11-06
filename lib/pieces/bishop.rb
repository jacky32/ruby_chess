# frozen_string_literal: false

require_relative '../piece'
require_relative '../movement'

# class for the bishop pieces
class Bishop < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color:, piece_position:)
    super
    assign_visual("\u265D")
  end

  def generate_all(board:)
    @possible_moves = generate_diagonal_moves(board: board)
    @possible_takes = @possible_moves
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all

  private

  def optional_move_checks_passed?(_start_coordinate, _end_coordinate)
    true # True or add checks
  end
end
