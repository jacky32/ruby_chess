# frozen_string_literal: false

require_relative '../piece'
require_relative '../translate'

# class for the rook pieces
class Rook < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265C")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    return true if valid_direction?(start_y, start_x, end_y, end_x)
  end

  def valid_direction?(start_y, start_x, end_y, end_x)
    return true if start_y == end_y
    return true if start_x == end_x

    false
  end

  def secondary_move_checks_passed?(start_coordinate, end_coordinate)
    return false if piece_in_way?(start_coordinate, end_coordinate)

    true
  end

  def piece_in_way?(start_coordinate, end_coordinate)
    board = assign_board
    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    return false if start_x == end_x && y_clean?(start_y, start_x, end_y, board)
    return false if start_y == end_y && x_clean?(start_y, start_x, end_x, board)

    true
  end

  def y_clean?(start_y, start_x, end_y, board)
    y = start_y < end_y ? (start_y..end_y).to_a : start_y.downto(end_y).to_a
    y.shift
    y.pop
    y.each do |id_y|
      return false unless board[id_y][start_x].empty?
    end

    true
  end

  def x_clean?(start_y, start_x, end_x, board)
    x = start_x < end_x ? (start_x..end_x).to_a : start_x.downto(end_x).to_a
    x.shift
    x.pop
    x.each do |id_x|
      return false unless board[start_y][id_x].empty?
    end

    true
  end

  def valid_take?(start_coordinate, end_coordinate)
    return false if piece_in_way?(start_coordinate, end_coordinate)

    enemy_on_tile?(end_coordinate)
  end
end
