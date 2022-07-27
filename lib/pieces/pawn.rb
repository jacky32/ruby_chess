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

    if @piece_color == 'white'
      return valid_forward_two?(end_coordinate) if start_coordinate['id_y'] - end_coordinate['id_y'] == 2
      return valid_forward_one?(end_coordinate) if start_coordinate['id_y'] - end_coordinate['id_y'] == 1
    else
      return valid_forward_two?(end_coordinate) if end_coordinate['id_y'] - start_coordinate['id_y'] == 2
      return valid_forward_one?(end_coordinate) if end_coordinate['id_y'] - start_coordinate['id_y'] == 1
    end

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

  # move one tile forward
  def valid_forward_one?(end_coordinate)
    return false if enemy_in_way?(end_coordinate)

    true
  end

  # move two tiles forward if haven't moved yet
  def valid_forward_two?(end_coordinate)
    return false unless @piece_moves.empty?
    return false if enemy_in_way?(end_coordinate)

    true
  end

  def valid_take?(start_coordinate, end_coordinate)
    valid_cross_take?(start_coordinate, end_coordinate)
  end

end
