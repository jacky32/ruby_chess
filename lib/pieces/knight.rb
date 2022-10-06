# frozen_string_literal: false

require_relative '../piece'

# class for the knight pieces
class Knight < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color:, piece_position:)
    super
    assign_visual("\u265E")
  end

  def generate_all(board:)
    @possible_moves = []

    # generates vertical moves
    generate_knight_moves(id_y_plus: @id_y + 2, id_y_minus: @id_y - 2, id_x_plus: @id_x + 1, id_x_minus: @id_x - 1,
                          board: board)

    # generates horizontal moves
    generate_knight_moves(id_y_plus: @id_y + 1, id_y_minus: @id_y - 1, id_x_plus: @id_x + 2, id_x_minus: @id_x - 2,
                          board: board)

    @possible_takes = @possible_moves
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all

  private

  def generate_knight_moves(id_y_plus:, id_y_minus:, id_x_plus:, id_x_minus:, board:)
    if id_y_minus > 0
      @possible_moves << board[id_y_minus][id_x_plus] if id_x_plus < 9
      @possible_moves << board[id_y_minus][id_x_minus] if id_x_minus > 0
    end
    return unless id_y_plus < 9

    @possible_moves << board[id_y_plus][id_x_plus] if id_x_plus < 9
    @possible_moves << board[id_y_plus][id_x_minus] if id_x_minus > 0
  end

  def optional_move_checks_passed?(_start_coordinate, _end_coordinate)
    true # True or add checks
  end
end
