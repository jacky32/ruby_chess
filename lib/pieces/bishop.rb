# frozen_string_literal: false

require_relative '../piece'

# class for the bishop pieces
class Bishop < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265D")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless secondary_move_checks_passed?(end_coordinate)

    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    return false if diagonal_piece_in_way?(start_y, start_x, end_y, end_x)
    return false unless valid_diagonal_checks(start_y, start_x, end_y, end_x)

    true
  end

  def secondary_move_checks_passed?(end_coordinate)
    return false if friendly_on_tile?(end_coordinate)
    return false if enemy_on_tile?(end_coordinate)

    true
  end

  def valid_take?(start_coordinate, end_coordinate)
    if diagonal_piece_in_way?(start_coordinate['id_y'], start_coordinate['id_x'],
                              end_coordinate['id_y'], end_coordinate['id_x'])
      return false
    end

    enemy_on_tile?(end_coordinate)
  end
end
