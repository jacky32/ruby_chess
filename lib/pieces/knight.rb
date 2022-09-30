# frozen_string_literal: false

require_relative '../piece'

# class for the knight pieces
class Knight < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color:, piece_position:)
    super
    assign_visual("\u265E")
  end

  def generate_all
    @possible_moves = []

    # generates vertical moves
    generate_knight_moves(@id_y + 2, @id_y - 2, @id_x + 1, @id_x - 1)

    # generates horizontal moves
    generate_knight_moves(@id_y + 1, @id_y - 1, @id_x + 2, @id_x - 2)

    @possible_takes = @possible_moves
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all

  def generate_knight_moves(tid_y_plus, tid_y_minus, tid_x_plus, tid_x_minus, board = assign_board)
    if tid_y_minus > 0
      @possible_moves << board[tid_y_minus][tid_x_plus] unless tid_x_minus < 1
      @possible_moves << board[tid_y_minus][tid_x_minus] unless tid_x_plus > 8
    end
    return unless tid_y_plus < 9

    @possible_moves << board[tid_y_plus][tid_x_plus] unless tid_x_plus > 8
    @possible_moves << board[tid_y_plus][tid_x_minus] unless tid_x_minus < 1
  end

  # def valid_vertical?(start_y, start_x, end_y, end_x)
  #   return true if end_y == start_y + 2 && (end_x == start_x + 1 || end_x == start_x - 1)
  #   return true if end_y == start_y - 2 && (end_x == start_x + 1 || end_x == start_x - 1)

  #   false
  # end

  # def valid_horizontal?(start_y, start_x, end_y, end_x)
  #   return true if end_y == start_y + 1 && (end_x == start_x + 2 || end_x == start_x - 2)
  #   return true if end_y == start_y - 1 && (end_x == start_x + 2 || end_x == start_x - 2)

  #   false
  # end

  def optional_move_checks_passed?(_start_coordinate, _end_coordinate)
    true # True or add checks
  end
end
