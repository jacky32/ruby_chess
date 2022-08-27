# frozen_string_literal: false

require_relative '../piece'

# class for the rook pieces
class Rook < Piece
  attr_reader(:piece_color, :visual, :piece_moves, :type, :possible_moves, :possible_takes, :id_y, :id_x)

  def initialize(piece_color, type, piece_position)
    super
    assign_visual("\u265C")
  end

  def valid_move?(start_coordinate, end_coordinate)
    return false unless preliminary_move_checks_passed?(start_coordinate, end_coordinate)
    return false unless secondary_move_checks_passed?(start_coordinate, end_coordinate)

    generate_possible_moves

    return true if @possible_moves.include?(end_coordinate['tile'])

    false
  end

  def secondary_move_checks_passed?(_start_coordinate, _end_coordinate)
    true
  end

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
    loop do
      tile = assign_board[id_y][@id_x]
      if move_checks_passed?(tile)
        @possible_moves << tile
        @possible_takes << tile
      end
      break unless id_y > 0 && tile.empty?

      id_y -= 1
    end
  end

  def generate_y_up
    id_y = @id_y + 1
    loop do
      tile = assign_board[id_y][@id_x]
      if move_checks_passed?(tile)
        @possible_moves << tile
        @possible_takes << tile
      end
      break unless id_y < 9 && tile.empty?

      id_y += 1
    end
  end

  def generate_x_down
    id_x = @id_x - 1
    loop do
      tile = assign_board[@id_y][id_x]
      if move_checks_passed?(tile)
        @possible_moves << tile
        @possible_takes << tile
      end
      break unless id_x > 0 && tile.empty?

      id_x -= 1
    end
  end

  def generate_x_up
    id_x = @id_x + 1
    loop do
      tile = assign_board[@id_y][id_x]
      if move_checks_passed?(tile)
        @possible_moves << tile
        @possible_takes << tile
      end
      break unless id_x < 9 && tile.empty?

      id_x += 1
    end
  end

  def move_checks_passed?(tile)
    within_board_boundaries?({ 'id_y' => tile.id_y, 'id_x' => tile.id_x })
  end

  def valid_take?(_start_coordinate, end_coordinate)
    generate_possible_takes
    return false unless enemy_on_tile?(end_coordinate)

    @possible_takes.include?(end_coordinate['tile'])
  end
end
