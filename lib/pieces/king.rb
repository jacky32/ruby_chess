# frozen_string_literal: false

require_relative '../piece'

# class for the king pieces
class King < Piece
  attr_reader(:piece_color, :visual)

  def initialize(piece_color)
    super
    assign_visual("\u265A")
  end
end
