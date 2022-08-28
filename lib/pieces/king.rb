# frozen_string_literal: false

require_relative '../piece'

# class for the king pieces
class King < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265A")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    # return false unless valid_move_one_around?(start_y, start_x, end_y, end_x)

    generate_possible_moves

    return true if @possible_moves.include?(end_coordinate['tile'])

    true
  end

  def secondary_move_checks_passed?(_start_coordinate, end_coordinate)
    return false if possible_check?(end_coordinate)

    true
  end

  def generate_all
    @possible_moves = []
    @possible_moves << generate_one_around
    @possible_takes = @possible_moves
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all

  def generate_one_around
    board = assign_board
    generated_tiles = []
    (-1..1).to_a.each do |index|
      (-1..1).to_a.each do |index2|
        tid_y = @id_y + index
        tid_x = @id_x + index2
        generated_tiles << board[tid_y][tid_x] unless filter(tid_y, tid_x, board)
      end
    end
    generated_tiles
  end

  def filter(tid_y, tid_x, board)
    [tid_y, tid_x].any? { |a| a > 8 || a < 1 } ||
      (tid_y == @id_y && tid_x == @id_x) ||
      friendly_on_tile?({ 'value' => board[tid_y][tid_x].content })
  end

  def possible_check?(coordinate)
    pieces = assign_pieces
    pieces.any? do |piece|
      next if %w[queen king knight].include?(piece.type)

      piece.generate_possible_takes
      takes = piece.possible_takes
      takes.any? do |take|
        take.id_y == coordinate['id_y'] && take.id_x == coordinate['id_x']
      end
    end
  end

  # selects pieces of opposite color that exist on the board
  def assign_pieces
    ObjectSpace.each_object(BoardPiece).to_a.map(&:content).reject do |piece|
      piece.nil? || piece.piece_color == @piece_color
    end
  end
end
