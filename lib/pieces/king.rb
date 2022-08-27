# frozen_string_literal: false

require_relative '../piece'

# class for the king pieces
class King < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type)

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

    return false unless valid_move_one_around?(start_y, start_x, end_y, end_x)

    true
  end

  def secondary_move_checks_passed?(_start_coordinate, end_coordinate)
    return false if possible_check?(end_coordinate)

    true
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

  def valid_take?(start_coordinate, end_coordinate) end
end
