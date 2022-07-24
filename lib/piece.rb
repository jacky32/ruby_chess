# frozen_string_literal: false

# class for the general piece logic
class Piece
  attr_accessor(:piece_color, :piece_moves)

  def initialize(piece_color)
    @piece_color = piece_color
    @piece_moves = []
  end

  def move(second_coordinate)
    
  end

  def assign_visual(type)
    @visual = if @piece_color == 'black'
                "\e[30m #{type} \e[0m"
              else
                "\e[97m #{type} \e[0m"
              end
  end
end
