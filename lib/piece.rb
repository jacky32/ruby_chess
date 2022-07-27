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

  def take(id_y1, id_x1, id_y2, id_x2, board)
    first_piece = board.board[id_y1][id_x1].content
    first_piece.piece_moves << [[id_y1, translate_number_to_letter(id_x1)], [id_y2, translate_number_to_letter(id_x2)]]
    board.graveyard << board.board[id_y2][id_x2].content
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

  def valid_cross_take?(id_y1, id_x1, id_y2, id_x2, board)
    return false unless enemy_in_way?(id_y2, id_x2, board)

    if @piece_color == 'white'
      puts 'white'
      return false unless id_y2 == id_y1 - 1
    else
      return false unless id_y2 == id_y1 + 1
    end

    true
  end

  def enemy_in_way?(id_y2, id_x2, board)
    board.board[id_y2][id_x2].empty? ? false : true
  end

  def within_board_boundaries?(id_y2, id_x2)
    return true if (1..8).to_a.include?(id_y2) && (1..8).to_a.include?(id_x2)

    puts 'Invalid move! Outside of board boundaries'
    false
  end

  def different_coordinates?(id_y1, id_x1, id_y2, id_x2)
    return true if [id_y1, id_x1] != [id_y2, id_x2]

    puts 'Invalid move! The coordinates are the same'
    false
  end
end
