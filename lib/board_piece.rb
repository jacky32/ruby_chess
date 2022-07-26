# frozen_string_literal: false

require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/queen'
require_relative 'pieces/rook'

# class for each individual board tile
class BoardPiece
  attr_accessor(:content)
  attr_reader(:color, :id_x, :id_y)

  def initialize(id_y, id_x)
    @id_x = id_x
    @id_y = id_y
    @content = nil
    assign_color
  end

  def generate_piece(piece, piece_color, piece_position)
    @content = case piece
               when 'pawn' then Pawn.new(piece_color: piece_color, piece_position: piece_position)
               when 'knight' then Knight.new(piece_color: piece_color, piece_position: piece_position)
               when 'rook' then Rook.new(piece_color: piece_color, piece_position: piece_position)
               when 'bishop' then Bishop.new(piece_color: piece_color, piece_position: piece_position)
               when 'queen' then Queen.new(piece_color: piece_color, piece_position: piece_position)
               when 'king' then King.new(piece_color: piece_color, piece_position: piece_position)
               end
  end

  def remove_piece
    @content = nil
  end

  def empty?
    @content.nil?
  end

  private

  def assign_color
    @color = if @id_y.even?
               @id_x.even? ? 'white' : 'black'
             else
               @id_x.odd? ? 'white' : 'black'
             end
  end
end
