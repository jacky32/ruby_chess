# frozen_string_literal: false

require_relative '../piece'

# class for the queen pieces
class Queen < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265B")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)

    # return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    generate_possible_moves

    return true if @possible_moves.include?(end_coordinate['tile'])

    false
  end

  def generate_all
    @possible_moves = []
    generate_horizontal_and_vertical_moves
    @possible_takes = @possible_moves
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all

  # def secondary_move_checks_passed?(start_coordinate, end_coordinate) end

  def valid_take?(start_coordinate, end_coordinate) end
end
