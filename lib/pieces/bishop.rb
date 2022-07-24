# frozen_string_literal: false

require_relative '../piece'

# class for the bishop pieces
class Bishop < Piece
  attr_reader(:piece_color, :visual)

  def initialize(piece_color)
    super
    assign_visual("\u265D")
  end
end
