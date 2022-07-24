# frozen_string_literal: false

require_relative 'board_piece'

# class for the game environment
class Board
  def generate
    @board = Array.new(8) { |id_y| Array.new(8) { |id_x| BoardPiece.new(id_x, id_y) } }
    fill_with_pieces
    show_board
  end

  private

  def show_board
    @board.each do |row|
      row.each do |tile|
        if tile.color == 'black'
          print "\e[48;5;243m#{defined?(tile.content.visual) ? tile.content.visual : '   '}\e[0m"
        else
          print "\e[48;5;249m#{defined?(tile.content.visual) ? tile.content.visual : '   '}\e[0m"
        end
      end
      puts
    end
  end

  def fill_with_pieces
    fill_pawns
    fill_bishops
    fill_knights
    fill_rooks
    fill_queens
    fill_kings
  end

  def fill_pawns
    @board[1].each do |tile|
      tile.generate_piece('pawn', 'black')
    end

    @board[6].each do |tile|
      tile.generate_piece('pawn', 'white')
    end
  end

  def fill_rooks
    @board[0][0].generate_piece('rook', 'black')
    @board[0][7].generate_piece('rook', 'black')
    @board[7][0].generate_piece('rook', 'white')
    @board[7][7].generate_piece('rook', 'white')
  end

  def fill_bishops
    @board[0][2].generate_piece('bishop', 'black')
    @board[0][5].generate_piece('bishop', 'black')
    @board[7][2].generate_piece('bishop', 'white')
    @board[7][5].generate_piece('bishop', 'white')
  end

  def fill_knights
    @board[0][1].generate_piece('knight', 'black')
    @board[0][6].generate_piece('knight', 'black')
    @board[7][1].generate_piece('knight', 'white')
    @board[7][6].generate_piece('knight', 'white')
  end

  def fill_queens
    @board[0][3].generate_piece('queen', 'black')
    @board[7][3].generate_piece('queen', 'white')
  end

  def fill_kings
    @board[0][4].generate_piece('king', 'black')
    @board[7][4].generate_piece('king', 'white')
  end
end
