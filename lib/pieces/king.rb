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

  # redo all moves to possible moves array, if within possible moves -> valid?
  def possible_check?(coordinate)
    [
      possible_pawn_check?(coordinate),
      possible_bishop_check?(coordinate)
      # possible_knight_check?(coordinate),
      # possible_queen_check?(coordinate),
      # possible_rook_check?(coordinate)
    ].any?(true)
  end

  def possible_pawn_check?(coordinate)
    pawns = ObjectSpace.each_object(Pawn).to_a
    pawns.any? do |pawn|
      pawn.generate_possible_takes
      takes = pawn.possible_takes
      takes.any? do |take|
        take.id_y == coordinate['id_y'] && take.id_x == coordinate['id_x'] && pawn.piece_color != @piece_color
      end
    end
  end

  def possible_bishop_check?(coordinate)
    bishops = ObjectSpace.each_object(Bishop).to_a
    bishops.any? do |bishop|
      bishop.generate_possible_takes
      takes = bishop.possible_takes
      takes.any? do |take|
        take.id_y == coordinate['id_y'] && take.id_x == coordinate['id_x'] && pawn.piece_color != @piece_color
      end
    end
  end

  def possible_knight_check?(coordinate)
    pawns = ObjectSpace.each_object(Knight).to_a
    pawns.any? do |pawn|
      pawn.generate_possible_takes
      takes = pawn.possible_takes
      takes.any? do |take|
        take.id_y == coordinate['id_y'] && take.id_x == coordinate['id_x'] && pawn.piece_color != @piece_color
      end
    end
  end

  def possible_queen_check?(coordinate)
    pawns = ObjectSpace.each_object(Queen).to_a
    pawns.any? do |pawn|
      pawn.generate_possible_takes
      takes = pawn.possible_takes
      takes.any? do |take|
        take.id_y == coordinate['id_y'] && take.id_x == coordinate['id_x'] && pawn.piece_color != @piece_color
      end
    end
  end

  def possible_rook_check?(coordinate)
    pawns = ObjectSpace.each_object(Rook).to_a
    pawns.any? do |pawn|
      pawn.generate_possible_takes
      takes = pawn.possible_takes
      takes.any? do |take|
        take.id_y == coordinate['id_y'] && take.id_x == coordinate['id_x'] && pawn.piece_color != @piece_color
      end
    end
  end

  def valid_take?(start_coordinate, end_coordinate) end
end
