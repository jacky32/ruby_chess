# frozen_string_literal: false

require_relative '../piece'
require_relative '../movement'

# class for the rook pieces
class Rook < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color:, piece_position:)
    super
    assign_visual("\u265C")
  end

  def optional_move_checks_passed?(_start_coordinate, _end_coordinate)
    true # True or add checks
  end

  def generate_all
    @possible_moves = generate_horizontal_and_vertical_moves
    @possible_takes = @possible_moves
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all
end
