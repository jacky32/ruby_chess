# frozen_string_literal: false

require_relative '../piece'

# class for the queen pieces
class Queen < Piece
  attr_reader(:piece_color, :visual)

  def initialize(piece_color)
    super(piece_color)
    assign_visual("\u265B")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

  end
  
  def secondary_move_checks_passed?(start_coordinate, end_coordinate) end

  def valid_take?(start_coordinate, end_coordinate) end
end
