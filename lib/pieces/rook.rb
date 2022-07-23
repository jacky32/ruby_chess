# frozen_string_literal: false

# class for the rook pieces
class Rook
  attr_reader(:piece_color, :visual)

  def initialize(piece_color)
    @piece_color = piece_color
    assign_visual
  end

  def assign_visual
    @visual = if @piece_color == 'black'
                "\e[30m \u265C \e[0m"
              else
                "\e[97m \u265C \e[0m"
              end
  end
end
