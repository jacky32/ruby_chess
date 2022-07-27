# frozen_string_literal: false

require_relative '../piece'

# class for the pawn pieces
class Pawn < Piece
  attr_reader(:piece_color, :visual, :piece_moves)

  def initialize(piece_color)
    super
    assign_visual("\u265F")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_checks_passed?(start_coordinate, end_coordinate)
    return false if enemy_in_way?(end_coordinate)

    return true if valid_forward_two?(start_coordinate, end_coordinate)
    return true if valid_forward_one?(start_coordinate, end_coordinate)

    false
  end

  def preliminary_checks_passed?(start_coordinate, end_coordinate)
    # checks whether the board doesn't end
    return false unless within_board_boundaries?(end_coordinate)
    # checks whether coordinates are the same
    return false unless different_coordinates?(start_coordinate, end_coordinate)
    # checks whether in the same line
    return false if start_coordinate['id_x'] != end_coordinate['id_x']

    true
  end

  def valid_forward_one?(start_coordinate, end_coordinate)
    start_y = start_coordinate['id_y']
    end_y = end_coordinate['id_y']
    return true if start_y - end_y == 1 && @piece_color == 'white'
    return true if end_y - start_y == 1 && @piece_color == 'black'

    false
  end

  # move two tiles forward if haven't moved yet
  def valid_forward_two?(start_coordinate, end_coordinate)
    return false unless @piece_moves.empty?

    start_y = start_coordinate['id_y']
    end_y = end_coordinate['id_y']
    return true if start_y - end_y == 2 && @piece_color == 'white'
    return true if end_y - start_y == 2 && @piece_color == 'black'

    false
  end

  def valid_take?(start_coordinate, end_coordinate)
    valid_cross_take?(start_coordinate, end_coordinate)
  end
end
