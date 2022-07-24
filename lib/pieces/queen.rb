# frozen_string_literal: false

require_relative '../piece'

# class for the queen pieces
class Queen < Piece
  attr_reader(:piece_color, :visual)

  def initialize(piece_color)
    super(piece_color)
    assign_visual("\u265B")
  end
end
