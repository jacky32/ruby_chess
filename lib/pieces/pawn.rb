# frozen_string_literal: false

require_relative '../piece'

# class for the pawn pieces
class Pawn < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color:, piece_position:)
    super
    assign_visual("\u265F")
  end

  def valid_take?(start_coordinate:, end_coordinate:, **_)
    valid_cross_take?(start_coordinate: start_coordinate, end_coordinate: end_coordinate)
  end

  private

  def generate_possible_moves(board:)
    @possible_moves = []
    if @piece_color == 'white'
      generate_white_moves(board: board)
    else
      generate_black_moves(board: board)
    end
  end

  def generate_possible_takes(board:, id_y: @id_y, id_x: @id_x)
    @possible_takes = []
    if @piece_color == 'white'
      generate_white_takes(id_y: id_y, id_x: id_x, board: board)
    else
      generate_black_takes(id_y: id_y, id_x: id_x, board: board)
    end
  end

  def optional_move_checks_passed?(start_coordinate, end_coordinate)
    # checks whether in the same line
    return false if start_coordinate[:id_x] != end_coordinate[:id_x]

    true
  end

  def generate_white_moves(board:)
    @possible_moves << board[@id_y - 1, @id_x]
    @possible_moves << board[@id_y - 2, @id_x] if @piece_moves.empty?
  end

  def generate_black_moves(board:)
    @possible_moves << board[@id_y + 1, @id_x]
    @possible_moves << board[@id_y + 2, @id_x] if @piece_moves.empty?
  end

  def generate_white_takes(id_y:, id_x:, board:)
    @possible_takes << board[id_y - 1, id_x - 1] unless id_y - 1 < 1 || id_x - 1 < 1
    @possible_takes << board[id_y - 1, id_x + 1] unless id_y - 1 < 1 || id_x + 1 > 8
  end

  def generate_black_takes(id_y:, id_x:, board:)
    @possible_takes << board[id_y + 1, id_x - 1] unless id_y + 1 > 8 || id_x - 1 < 1
    @possible_takes << board[id_y + 1, id_x + 1] unless id_y + 1 > 8 || id_x + 1 > 8
  end

  def in_neighbouring_column?(start_x:, end_x:)
    return true if end_x == start_x + 1 || end_x == start_x - 1

    false
  end

  def valid_cross_take?(start_coordinate:, end_coordinate:)
    start_y = start_coordinate[:id_y]
    end_y = end_coordinate[:id_y]
    return false unless enemy_on_tile?(end_coordinate)
    return false unless in_neighbouring_column?(start_x: start_coordinate[:id_x], end_x: end_coordinate[:id_x])

    if @piece_color == 'white'
      return false unless end_y == start_y - 1
    else
      return false unless end_y == start_y + 1
    end

    true
  end
end
