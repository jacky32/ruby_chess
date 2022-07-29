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
    return false unless secondary_move_checks_passed?(end_coordinate)

    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    return false if piece_in_way?(start_y, start_x, end_y, end_x)
    return false unless valid_checks(start_y, start_x, end_y, end_x)

    true
  end

  def secondary_move_checks_passed?(end_coordinate)
    return false if friendly_on_tile?(end_coordinate)
    return false if enemy_on_tile?(end_coordinate)

    true
  end

  def piece_in_way?(start_y, start_x, end_y, end_x)
    distance = (end_y - start_y).abs

    return true if [
      piece_bottom_right?(distance, start_y, start_x, end_y, end_x),
      piece_bottom_left?(distance, start_y, start_x, end_y, end_x),
      piece_up_right?(distance, start_y, start_x, end_y, end_x),
      piece_up_left?(distance, start_y, start_x, end_y, end_x)
    ].any?(true)

    false
  end

  def piece_bottom_right?(distance, start_y, start_x, end_y, end_x)
    if end_y > start_y && end_x > start_x
      1.upto(distance - 1) do |increment|
        return true unless assign_board[start_y + increment][start_x + increment].empty?
      end
    end

    false
  end

  def piece_bottom_left?(distance, start_y, start_x, end_y, end_x)
    if end_y > start_y && end_x < start_x
      1.upto(distance - 1) do |increment|
        return true unless assign_board[start_y + increment][start_x - increment].empty?
      end
    end

    false
  end

  def piece_up_right?(distance, start_y, start_x, end_y, end_x)
    if end_y < start_y && end_x > start_x
      1.upto(distance - 1) do |increment|
        return true unless assign_board[start_y - increment][start_x + increment].empty?
      end
    end

    false
  end

  def piece_up_left?(distance, start_y, start_x, end_y, end_x)
    if end_y < start_y && end_x < start_x
      1.upto(distance - 1) do |increment|
        return true unless assign_board[start_y - increment][start_x - increment].empty?
      end
    end

    false
  end

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

  def valid_take?(start_coordinate, end_coordinate)
    if piece_in_way?(start_coordinate['id_y'], start_coordinate['id_x'], end_coordinate['id_y'], end_coordinate['id_x'])
      return false
    end

    enemy_on_tile?(end_coordinate)
  end
end
