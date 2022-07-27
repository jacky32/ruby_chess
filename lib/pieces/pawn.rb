# frozen_string_literal: false

require_relative '../piece'

# class for the pawn pieces
class Pawn < Piece
  attr_reader(:piece_color, :visual, :piece_moves)

  def initialize(piece_color)
    super
    assign_visual("\u265F")
  end

  def valid_move?(id_y1, id_x1, id_y2, id_x2, board)
    return false unless preliminary_checks_passed?(id_y1, id_x1, id_y2, id_x2)

    if @piece_color == 'white'
      return valid_forward_two?(id_y2, id_x2, board) if id_y1 - id_y2 == 2
      return valid_forward_one?(id_y2, id_x2, board) if id_y1 - id_y2 == 1
    else
      return valid_forward_two?(id_y2, id_x2, board) if id_y2 - id_y1 == 2
      return valid_forward_one?(id_y2, id_x2, board) if id_y2 - id_y1 == 1
    end

    false
  end

  def preliminary_checks_passed?(id_y1, id_x1, id_y2, id_x2)
    # checks whether the board doesn't end
    return false unless within_board_boundaries?(id_y2, id_x2)
    # checks whether coordinates are the same
    return false unless different_coordinates?(id_y1, id_x1, id_y2, id_x2)
    # checks whether in the same line
    return false if id_x1 != id_x2

    true
  end

  # move one tile forward
  def valid_forward_one?(id_y2, id_x2, board)
    return false if enemy_in_way?(id_y2, id_x2, board)

    true
  end

  # move two tiles forward if haven't moved yet
  def valid_forward_two?(id_y2, id_x2, board)
    return false unless @piece_moves.empty?
    return false if enemy_in_way?(id_y2, id_x2, board)

    true
  end

  def valid_take?(id_y1, id_x1, id_y2, id_x2, board)
    valid_cross_take?(id_y1, id_x1, id_y2, id_x2, board)
  end

end
