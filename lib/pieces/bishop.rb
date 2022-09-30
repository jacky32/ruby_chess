# frozen_string_literal: false

require_relative '../piece'
require_relative '../movement'

# class for the bishop pieces
class Bishop < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265D")
  end

  def generate_all
    @possible_moves = generate_diagonal_moves
    @possible_takes = @possible_moves
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all

  def optional_move_checks_passed?(_start_coordinate, _end_coordinate)
    true # True or add checks
  end

  # def valid_take?(_start_coordinate, end_coordinate)
  #   generate_possible_takes
  #   @possible_takes.any? do |take|
  #     take.id_y == end_coordinate['id_y'] && take.id_x == end_coordinate['id_x']
  #     enemy_on_tile?({ 'value' => assign_board[take.id_y][take.id_x].content })
  #   end
  # end
end
