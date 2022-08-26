# frozen_string_literal: false

require_relative '../piece'

# class for the bishop pieces
class Bishop < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265D")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    generate_possible_moves(start_coordinate['id_y'], start_coordinate['id_x'])

    return true if @possible_moves.include?(end_coordinate['tile'])

    false
  end

  def generate_possible_moves(_id_y, _id_x)
    # select empty board tiles
    board_pieces = ObjectSpace.each_object(BoardPiece).to_a

    # check whether the tile id matches possible bishop route
    board_pieces.select! do |tile|
      filter_selection(id_y, id_x, tile)
    end

    @possible_moves = board_pieces.map { |tile| assign_board[tile.id_y][tile.id_x] }
  end

  def generate_possible_takes(id_y = @id_y, id_x = @id_x)
    board = assign_board
    board_pieces = ObjectSpace.each_object(BoardPiece).to_a.select do |tile|
      filter_selection(id_y, id_x, tile)
    end

    @possible_takes = board_pieces.map { |tile| board[tile.id_y][tile.id_x] }
  end

  def filter_selection(id_y, id_x, tile)
    tid_y = tile.id_y
    tid_x = tile.id_x
    valid_diagonal_checks(id_y, id_x, tid_y, tid_x) &&
      within_board_boundaries?({ 'id_y' => tid_y, 'id_x' => tid_x }) &&
      !diagonal_piece_in_way?(id_y, id_x, tid_y, tid_x)
  end

  def secondary_move_checks_passed?(start_coordinate, end_coordinate)
    start_y = start_coordinate['id_y']
    start_x = start_coordinate['id_x']
    end_y = end_coordinate['id_y']
    end_x = end_coordinate['id_x']

    return false if diagonal_piece_in_way?(start_y, start_x, end_y, end_x)
    return false unless valid_diagonal_checks(start_y, start_x, end_y, end_x)

    true
  end

  def valid_take?(_start_coordinate, end_coordinate)
    generate_possible_takes
    @possible_takes.any? do |take|
      take.id_y == end_coordinate['id_y'] && take.id_x == end_coordinate['id_x']
      enemy_on_tile?({ 'value' => assign_board[tile.id_y][tile.id_x].content })
    end
  end
end
