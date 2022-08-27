# frozen_string_literal: false

require_relative '../piece'
require_relative '../translate'

# class for the rook pieces
class Rook < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265C")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    generate_possible_moves
    @possible_moves.sort_by!(&:id_y)
    print 'final, ', [end_coordinate['id_y'], end_coordinate['id_x']]
    @possible_moves.each { |move| print 'current, ', [move.id_y, move.id_x], puts }

    return true if @possible_moves.include?(end_coordinate['tile'])
  end

  def secondary_move_checks_passed?(_start_coordinate, _end_coordinate)
    true
  end

  # TODO: fix generating tiles outside the border
  def generate_all
    @possible_moves = []
    @possible_takes = []
    generate_y_down
    generate_y_up
    generate_x_down
    generate_x_up
  end

  alias generate_possible_moves generate_all
  alias generate_possible_takes generate_all

  def generate_y_down
    id_y = @id_y - 1
    board = assign_board
    loop do
      @possible_moves << board[id_y][@id_x] if board[id_y][@id_x].empty?
      @possible_takes << board[id_y][@id_x]
      break unless id_y > 0 && board[id_y][@id_x].empty?

      id_y -= 1
    end
  end

  def generate_y_up
    id_y = @id_y + 1
    board = assign_board
    loop do
      @possible_moves << board[id_y][@id_x] if board[id_y][@id_x].empty?
      @possible_takes << board[id_y][@id_x]
      break unless id_y < 9 && board[id_y][@id_x].empty?

      id_y += 1
    end
  end

  def generate_x_down
    id_x = @id_x - 1
    board = assign_board
    loop do
      @possible_moves << board[@id_y][id_x] if board[@id_y][id_x].empty?
      @possible_takes << board[@id_y][id_x]
      break unless id_x > 0 && board[@id_y][id_x].empty?

      id_x -= 1
    end
  end

  def generate_x_up
    id_x = @id_x + 1
    board = assign_board
    loop do
      @possible_moves << board[@id_y][id_x] if board[@id_y][id_x].empty?
      @possible_takes << board[@id_y][id_x]
      break unless id_x < 9 && board[@id_y][id_x].empty?

      id_x += 1
    end
  end

  def valid_take?(_start_coordinate, end_coordinate)
    generate_possible_takes
    return false unless enemy_on_tile?(end_coordinate)

    @possible_takes.include?(end_coordinate['tile'])
  end
end
