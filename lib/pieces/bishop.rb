# frozen_string_literal: false

require_relative '../piece'

# class for the bishop pieces
class Bishop < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type)

  def initialize(piece_color, type)
    super
    assign_visual("\u265D")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    # return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    return false unless valid_checks(start_y, start_x, end_y, end_x)

    true
  end

  def secondary_move_checks_passed?(start_coordinate, end_coordinate) end

  def valid_checks(start_y, start_x, end_y, end_x)
    return false unless [
      end_y > start_y && end_x > start_x, # bottom right
      end_y > start_y && end_x < start_x, # bottom left
      end_y < start_y && end_x > start_x, # up right
      end_y < start_y && end_x < start_x # up left
    ].any?(true)

    distance_y = (end_y - start_y).abs
    distance_x = (end_x - start_x).abs

    distance_y == distance_x
  end

  def valid_take?(start_coordinate, end_coordinate) end
end
