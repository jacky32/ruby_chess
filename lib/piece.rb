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

  def valid_move?(start_coordinate:, end_coordinate:, board:)
    return false unless basic_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless optional_move_checks_passed?(start_coordinate, end_coordinate)

    generate_possible_moves(board: board)

    return true if @possible_moves.include?(end_coordinate[:tile])

    false
  end

  def valid_take?(end_coordinate:, board:, **_)
    generate_possible_takes(board: board)
    return false unless enemy_on_tile?(end_coordinate)

    @possible_takes.include?(end_coordinate[:tile])
  end

  def add_to_piece_history(piece:, start_id_y:, start_id_x:, end_id_y:, end_id_x:)
    piece.piece_moves << [
      [start_id_y, Translate.number_to_letter(number: start_id_x)],
      [end_id_y, Translate.number_to_letter(number: end_id_x)]
    ]
  end

  def remove_last_from_piece_history(piece:)
    piece.piece_moves.pop
  end

  def refresh_piece_position(id_y:, id_x:)
    @id_y = id_y
    @id_x = id_x
  end

  private

  def assign_visual(type)
    @visual = if @piece_color == 'black'
                "\e[30m #{type} \e[0m"
              else
                "\e[38:5:5m #{type} \e[0m"
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
end
