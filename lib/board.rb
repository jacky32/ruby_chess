# frozen_string_literal: false

require_relative 'board_piece'
require_relative 'translate'

# class for the game environment
class Board
  attr_accessor(:board, :graveyard)

  include Translate

  def initialize
    @board = create_board
    @graveyard = []
  end

  def populate
    fill_with_pieces
  end

  def [](id_y, id_x)
    @board[id_y][id_x]
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

  def all_pieces
    pieces = []
    @board.each_with_index do |row, id_y|
      row.each_with_index do |_tile, id_x|
        next if [0, 9].any?(id_x || id_y)

        pieces << @board[id_y][id_x].content unless @board[id_y][id_x].content.nil?
      end
    end
    pieces
  end

  private

  def create_board
    Array.new(10) { |id_y| Array.new(10) { |id_x| BoardPiece.new(id_y, id_x) } }
  end

  def print_helper_letters(id_x)
    # print empty corners
    print '   ' if [0, 9].include?(id_x)
    # print letters
    print " #{translate_number_to_letter(id_x)} " if (1..8).to_a.include?(id_x)
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
      tile.generate_piece('pawn', 'black', { id_y: 2, id_x: tile.id_x }) unless tile.id_y.zero? || tile.id_y == 9
    end

    @board[7].each do |tile|
      tile.generate_piece('pawn', 'white', { id_y: 7, id_x: tile.id_x }) unless tile.id_y.zero? || tile.id_y == 9
    end
  end

  def fill_rooks
    @board[1][1].generate_piece('rook', 'black', { id_y: 1, id_x: 1 })
    @board[8][1].generate_piece('rook', 'white', { id_y: 8, id_x: 1 })
    @board[1][8].generate_piece('rook', 'black', { id_y: 1, id_x: 8 })
    @board[8][8].generate_piece('rook', 'white', { id_y: 8, id_x: 8 })
  end

  def fill_bishops
    @board[1][3].generate_piece('bishop', 'black', { id_y: 1, id_x: 3 })
    @board[1][6].generate_piece('bishop', 'black', { id_y: 1, id_x: 6 })
    @board[8][3].generate_piece('bishop', 'white', { id_y: 8, id_x: 3 })
    @board[8][6].generate_piece('bishop', 'white', { id_y: 8, id_x: 6 })
  end

  def fill_knights
    @board[1][2].generate_piece('knight', 'black', { id_y: 1, id_x: 2 })
    @board[1][7].generate_piece('knight', 'black', { id_y: 1, id_x: 7 })
    @board[8][2].generate_piece('knight', 'white', { id_y: 8, id_x: 2 })
    @board[8][7].generate_piece('knight', 'white', { id_y: 8, id_x: 7 })
  end

  def fill_queens
    @board[1][4].generate_piece('queen', 'black', { id_y: 1, id_x: 4 })
    @board[8][4].generate_piece('queen', 'white', { id_y: 8, id_x: 4 })
  end

  def fill_kings
    @board[1][5].generate_piece('king', 'black', { id_y: 1, id_x: 5 })
    @board[8][5].generate_piece('king', 'white', { id_y: 8, id_x: 5 })
  end
end
