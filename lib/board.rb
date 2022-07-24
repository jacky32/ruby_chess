# frozen_string_literal: false

require_relative 'board_piece'

# class for the game environment
class Board
  attr_accessor(:board)

  def generate
    @board = Array.new(10) { |id_x| Array.new(10) { |id_y| BoardPiece.new(id_x, id_y) } }
    fill_with_pieces
    show_board
  end

  def show_board
    @board.each_with_index do |row, id_y|
      row.each_with_index do |tile, id_x|
        print_helper_letters(id_x) if [0, 9].include?(id_y)
        print_helper_numbers(id_y) if [0, 9].include?(id_x)
        print_colors(tile) unless [0, 9].include?(id_y) || [0, 9].include?(id_x)
      end
      puts
    end
  end

  private

  def print_helper_letters(id_x)
    # print empty corners
    print '   ' if [0, 9].include?(id_x)
    # print letters
    letters_in_numbers = {}
    ('a'..'h').each_with_index { |letter, number| letters_in_numbers[number + 1] = letter }
    print " #{letters_in_numbers[id_x]} " if (1..8).to_a.include?(id_x)
  end

  def print_helper_numbers(id_y)
    print " #{9 - id_y} " if (1..8).to_a.include?(id_y)
  end

  def print_colors(tile)
    if tile.color == 'black'
      print "\e[48;5;243m#{defined?(tile.content.visual) ? tile.content.visual : '   '}\e[0m"
    else
      print "\e[48;5;249m#{defined?(tile.content.visual) ? tile.content.visual : '   '}\e[0m"
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
    @board[2].each do |tile|
      tile.generate_piece('pawn', 'black') unless tile.id_y.zero? || tile.id_y == 9
    end

    @board[7].each do |tile|
      tile.generate_piece('pawn', 'white') unless tile.id_y.zero? || tile.id_y == 9
    end
  end

  def fill_rooks
    @board[1][1].generate_piece('rook', 'black')
    @board[1][8].generate_piece('rook', 'black')
    @board[8][1].generate_piece('rook', 'white')
    @board[8][8].generate_piece('rook', 'white')
  end

  def fill_bishops
    @board[1][3].generate_piece('bishop', 'black')
    @board[1][6].generate_piece('bishop', 'black')
    @board[8][3].generate_piece('bishop', 'white')
    @board[8][6].generate_piece('bishop', 'white')
  end

  def fill_knights
    @board[1][2].generate_piece('knight', 'black')
    @board[1][7].generate_piece('knight', 'black')
    @board[8][2].generate_piece('knight', 'white')
    @board[8][7].generate_piece('knight', 'white')
  end

  def fill_queens
    @board[1][4].generate_piece('queen', 'black')
    @board[8][4].generate_piece('queen', 'white')
  end

  def fill_kings
    @board[1][5].generate_piece('king', 'black')
    @board[8][5].generate_piece('king', 'white')
  end
end
