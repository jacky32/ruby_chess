# frozen_string_literal: false

require_relative '../piece'

# class for the pawn pieces
class Pawn < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265F")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    generate_possible_moves(start_coordinate, end_coordinate)

    return true if @possible_moves.include?(end_coordinate['tile'])

    false
  end

  def secondary_move_checks_passed?(start_coordinate, end_coordinate)
    # checks whether in the same line
    return false if start_coordinate['id_x'] != end_coordinate['id_x']

    true
  end

  def generate_possible_moves(start_coordinate, end_coordinate)
    id_y = start_coordinate['id_y']
    id_x = start_coordinate['id_x']
    board = assign_board

    if @piece_color == 'white'
      generate_white_moves(id_y, id_x, board, start_coordinate, end_coordinate)
    else
      generate_black_moves(id_y, id_x, board, start_coordinate, end_coordinate)
    end
  end

  def generate_white_moves(id_y, id_x, board, start_coordinate, end_coordinate)
    @possible_moves << board[id_y - 1][id_x] if valid_forward_one?(start_coordinate, end_coordinate)
    @possible_moves << board[id_y - 2][id_x] if valid_forward_two?(start_coordinate, end_coordinate)
  end

  def generate_black_moves(id_y, id_x, board, start_coordinate, end_coordinate)
    @possible_moves << board[id_y + 1][id_x] if valid_forward_one?(start_coordinate, end_coordinate)
    @possible_moves << board[id_y + 2][id_x] if valid_forward_two?(start_coordinate, end_coordinate)
  end

  def generate_possible_takes(id_y = @id_y, id_x = @id_x)
    board = assign_board
    @possible_takes = []
    if @piece_color == 'white'
      generate_white_takes(id_y, id_x, board)
    else
      generate_black_takes(id_y, id_x, board)
    end
  end

  def generate_white_takes(id_y, id_x, board)
    @possible_takes << board[id_y - 1][id_x - 1] unless id_y - 1 < 1 || id_x - 1 < 1
    @possible_takes << board[id_y - 1][id_x + 1] unless id_y - 1 < 1 || id_x + 1 > 8
  end

  def generate_black_takes(id_y, id_x, board)
    @possible_takes << board[id_y + 1][id_x - 1] unless id_y + 1 > 8 || id_x - 1 < 1
    @possible_takes << board[id_y + 1][id_x + 1] unless id_y + 1 > 8 || id_x + 1 > 8
  end

  def valid_forward_one?(start_coordinate, end_coordinate)
    start_y = start_coordinate['id_y']
    end_y = end_coordinate['id_y']
    return true if start_y - end_y == 1 && @piece_color == 'white'
    return true if end_y - start_y == 1 && @piece_color == 'black'

    false
  end

  # move two tiles forward if haven't moved yet
  def valid_forward_two?(start_coordinate, end_coordinate)
    return false unless @piece_moves.empty?

    start_y = start_coordinate['id_y']
    end_y = end_coordinate['id_y']
    return true if start_y - end_y == 2 && @piece_color == 'white'
    return true if end_y - start_y == 2 && @piece_color == 'black'

    false
  end

  def in_neighbouring_column?(start_coordinate, end_coordinate)
    start_x = start_coordinate['id_x']
    end_x = end_coordinate['id_x']
    return true if end_x == start_x + 1 || end_x == start_x - 1

    false
  end

  def valid_cross_take?(start_coordinate, end_coordinate)
    start_y = start_coordinate['id_y']
    end_y = end_coordinate['id_y']
    return false unless enemy_on_tile?(end_coordinate)
    return false unless in_neighbouring_column?(start_coordinate, end_coordinate)

    if @piece_color == 'white'
      return false unless end_y == start_y - 1
    else
      return false unless end_y == start_y + 1
    end

    true
  end

  def valid_take?(start_coordinate, end_coordinate)
    valid_cross_take?(start_coordinate, end_coordinate)
  end
end
