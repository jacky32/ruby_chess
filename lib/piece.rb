# frozen_string_literal: false

require_relative 'translate'
require_relative 'movement'

# class for the general piece logic
class Piece
  attr_accessor(:piece_color, :piece_moves, :type)

  include Translate
  include Movement

  def initialize(piece_color, type)
    @piece_color = piece_color
    @piece_moves = []
    @possible_moves = []
    @type = type
  end

  def add_to_piece_history(start_coordinate, end_coordinate)
    start_coordinate['value'].piece_moves << [
      [start_coordinate['id_y'], translate_number_to_letter(start_coordinate['id_x'])],
      [end_coordinate['id_y'], translate_number_to_letter(end_coordinate['id_x'])]
    ]
  end

  def add_to_graveyard(piece, board)
    board.graveyard << [piece.type, piece.piece_color]
  end

  def assign_visual(type)
    @visual = if @piece_color == 'black'
                "\e[30m #{type} \e[0m"
              else
                "\e[97m #{type} \e[0m"
              end
  end

  def preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    # checks whether the board doesn't end
    return false unless within_board_boundaries?(end_coordinate)
    # checks whether coordinates are the same
    return false unless different_coordinates?(start_coordinate, end_coordinate)
    return false if enemy_on_tile?(end_coordinate)
    return false if friendly_on_tile?(end_coordinate)

    true
  end

  def friendly_on_tile?(coordinate)
    return false if coordinate['value'].nil?
    return false if coordinate['value'].piece_color != @piece_color

    true
  end

  def enemy_on_tile?(coordinate)
    return false if coordinate['value'].nil?
    return false if coordinate['value'].piece_color == @piece_color

    true
  end

  def within_board_boundaries?(coordinate)
    return true if (1..8).to_a.include?(coordinate['id_y']) && (1..8).to_a.include?(coordinate['id_x'])

    puts 'Invalid move! Outside of board boundaries'
    false
  end

  def different_coordinates?(start_coordinate, end_coordinate)
    if [start_coordinate['id_y'], start_coordinate['id_x']] != [end_coordinate['id_y'], end_coordinate['id_x']]
      true
    else
      puts 'Invalid move! The coordinates are the same'
      false
    end
  end

  def assign_board
    ObjectSpace.each_object(Board).to_a[0].board
  end
end
