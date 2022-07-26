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
    # TODO: check whether enemy piece is there
    return false if id_x1 != id_x2

    return valid_forward_two?(id_y2, id_x2, board) if id_y1 - id_y2 == 2 || id_y2 - id_y1 == 2
    return valid_forward_one?(id_y2, id_x2, board) if id_y1 - id_y2 == 1 || id_y2 - id_y1 == 1

    false
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
end
