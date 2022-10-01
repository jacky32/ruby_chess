# frozen_string_literal: false

require_relative 'translate'
require_relative 'movement'

# class for the general piece logic
class Piece
  attr_accessor(:piece_color, :piece_moves, :id_y, :id_x)

  include Translate
  include Movement

  def initialize(piece_color:, piece_position:)
    @piece_color = piece_color
    @piece_moves = []
    @possible_moves = []
    @possible_takes = []
    @id_y = piece_position[:id_y]
    @id_x = piece_position[:id_x]
  end

  # def move(start_coordinate, end_coordinate)
  #   return unless valid_move?(start_coordinate, end_coordinate)

  #   add_to_piece_history(start_coordinate, end_coordinate)
  #   refresh_piece_position(end_coordinate)
  #   end_coordinate[:tile].content = start_coordinate[:value]
  #   start_coordinate[:tile].remove_piece
  # end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless basic_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless optional_move_checks_passed?(start_coordinate, end_coordinate)

    generate_possible_moves

    return true if @possible_moves.include?(end_coordinate[:tile])

    false
  end

  # def take(start_coordinate, end_coordinate, board)
  #   return unless valid_take?(start_coordinate, end_coordinate)

  #   add_to_graveyard(end_coordinate[:value], board)
  #   move(start_coordinate, end_coordinate)
  # end

  def valid_take?(_start_coordinate, end_coordinate)
    generate_possible_takes
    return false unless enemy_on_tile?(end_coordinate)

    @possible_takes.include?(end_coordinate[:tile])
  end

  def add_to_piece_history(start_coordinate, end_coordinate)
    start_coordinate[:value].piece_moves << [
      [start_coordinate[:id_y], translate_number_to_letter(start_coordinate[:id_x])],
      [end_coordinate[:id_y], translate_number_to_letter(end_coordinate[:id_x])]
    ]
  end

  def refresh_piece_position(coordinate)
    @id_y = coordinate[:id_y]
    @id_x = coordinate[:id_x]
  end

  def assign_visual(type)
    @visual = if @piece_color == 'black'
                "\e[30m #{type} \e[0m"
              else
                "\e[97m #{type} \e[0m"
              end
  end

  def basic_move_checks_passed?(start_coordinate, end_coordinate)
    # checks whether the board doesn't end
    return false unless within_board_boundaries?(end_coordinate)
    # checks whether coordinates are the same
    return false unless different_coordinates?(start_coordinate, end_coordinate)
    return false if enemy_on_tile?(end_coordinate)
    return false if friendly_on_tile?(end_coordinate)

    true
  end

  def friendly_on_tile?(coordinate)
    return false if coordinate[:value].nil?
    return false if coordinate[:value].piece_color != @piece_color

    true
  end

  def enemy_on_tile?(coordinate)
    return false if coordinate[:value].nil?
    return false if coordinate[:value].piece_color == @piece_color

    true
  end

  def within_board_boundaries?(coordinate)
    (1..8).to_a.include?(coordinate[:id_y]) && (1..8).to_a.include?(coordinate[:id_x])
  end

  def different_coordinates?(start_coordinate, end_coordinate)
    [start_coordinate[:id_y], start_coordinate[:id_x]] != [end_coordinate[:id_y], end_coordinate[:id_x]]
  end

  def assign_board
    ObjectSpace.each_object(Board).to_a[0].board
  end
end
