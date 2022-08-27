# frozen_string_literal: false

require_relative '../piece'

# class for the knight pieces
class Knight < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265E")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)

    # return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    # start_y = start_coordinate['id_y']
    # start_x = start_coordinate['id_x']
    # end_y = end_coordinate['id_y']
    # end_x = end_coordinate['id_x']

    # return true if valid_vertical?(start_y, start_x, end_y, end_x) || valid_horizontal?(start_y, start_x, end_y, end_x)

    generate_possible_moves

    return true if @possible_moves.include?(end_coordinate['tile'])

    false
  end

  def generate_all
    @possible_moves = []

    # generates vertical moves
    @possible_moves << generate_knight_moves(@id_y + 2, @id_y - 2, @id_x + 1, @id_x - 1)

    # generates horizontal moves
    @possible_moves << generate_knight_moves(@id_y + 1, @id_y - 1, @id_x + 2, @id_x - 2)
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all

  def generate_knight_moves(tid_y_plus, tid_y_minus, tid_x_plus, tid_x_minus)
    board = assign_board
    [board[tid_y_plus][tid_x_plus],
     board[tid_y_plus][tid_x_minus],
     board[tid_y_minus][tid_x_plus],
     board[tid_y_minus][tid_x_minus]]
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

  def generate_possible_takes; end

  # def secondary_move_checks_passed?(start_coordinate, end_coordinate) end

  def valid_take?(start_coordinate, end_coordinate)
    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    unless valid_vertical?(start_y, start_x, end_y, end_x) || valid_horizontal?(start_y, start_x, end_y, end_x)
      return false
    end

    enemy_on_tile?(end_coordinate)
  end
end
