# frozen_string_literal: false

require_relative 'translate'

# class for the general piece logic
class Piece
  attr_accessor(:piece_color, :piece_moves)

  include Translate

  def initialize(piece_color)
    @piece_color = piece_color
    @piece_moves = []
  end

  def move(id_y1, id_x1, id_y2, id_x2, board)
    first_piece = board.board[id_y1][id_x1].content
    first_piece.piece_moves << [[id_y1, translate_number_to_letter(id_x1)], [id_y2, translate_number_to_letter(id_x2)]]
    board.board[id_y2][id_x2].content = first_piece
    board.board[id_y1][id_x1].remove_piece
  end

  def assign_visual(type)
    @visual = if @piece_color == 'black'
                "\e[30m #{type} \e[0m"
              else
                "\e[97m #{type} \e[0m"
              end
  end

  def enemy_in_way?(id_y2, id_x2, board)
    board.board[id_y2][id_x2].empty? ? false : true
  end
end
