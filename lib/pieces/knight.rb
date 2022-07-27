# frozen_string_literal: false

require_relative '../piece'

# class for the knight pieces
class Knight < Piece
  attr_reader(:piece_color, :visual)

  def initialize(piece_color)
    super
    assign_visual("\u265E")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    # return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    return true if valid_vertical?(start_y, start_x, end_y, end_x) || valid_horizontal?(start_y, start_x, end_y, end_x)

    false
  end

  def valid_vertical?(start_y, start_x, end_y, end_x)
    return true if end_y == start_y + 2 && (end_x == start_x + 1 || end_x == start_x - 1)
    return true if end_y == start_y - 2 && (end_x == start_x + 1 || end_x == start_x - 1)

    false
  end

  def valid_horizontal?(start_y, start_x, end_y, end_x)
    return true if end_y == start_y + 1 && (end_x == start_x + 2 || end_x == start_x - 2)
    return true if end_y == start_y - 1 && (end_x == start_x + 2 || end_x == start_x - 2)

    false
  end

  def secondary_move_checks_passed?(start_coordinate, end_coordinate) end

  def valid_take?(start_coordinate, end_coordinate)

    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    unless valid_vertical?(start_y, start_x, end_y, end_x) || valid_horizontal?(start_y, start_x, end_y, end_x)
      return false
    end

    enemy_in_way?(end_coordinate)
  end
end
