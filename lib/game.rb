# rubocop: disable Metrics/ClassLength
# frozen_string_literal: false

require_relative 'board'
require_relative 'player'
require_relative 'translate'
require_relative 'process_input_output'
require_relative 'save_load'

# main class for the game
class Game
  attr_reader :board

  include ProcessInputOutput
  include Translate
  include SaveLoad

  def initialize
    clear_board
    @board = Board.new
  end

  def start
    unless load?
      generate_players
      @board.populate
      show_board
    end
    game_loop
  end

  def game_loop
    @current_player = @white_player
    loop do
      show_gameloop
      processed = false
      while processed == false
        coordinates = process_input
        unless coordinates == false
          processed = decide_piece_move(start_coordinate: coordinates[:start],
                                        end_coordinate: coordinates[:end])
        end
      end
      break if checkmate?

      # switch_current_player
    end
  end

  def switch_current_player
    @current_player = @current_player == @white_player ? @black_player : @white_player
  end

  def checkmate?; end

  def king_in_check?
    king = @board.all_pieces.select do |piece|
      piece.instance_of?(King) && piece.piece_color == @current_player.color
    end.first
    possible_king_check?(coordinate: { id_y: king.id_y, id_x: king.id_x })
  end

  def possible_king_check?(coordinate:, color: @current_player.color)
    @board.all_pieces.any? do |piece|
      next if piece.piece_color == color

      piece.generate_possible_takes(board: @board)
      piece.possible_takes.any? do |take|
        take.id_y == coordinate[:id_y] && take.id_x == coordinate[:id_x]
      end
    end
  end

  def generate_players
    @white_player = Player.new('white')
    @black_player = Player.new('black')
  end

  def decide_piece_move(start_coordinate:, end_coordinate:)
    start_piece = start_coordinate[:value]

    if start_piece.instance_of?(King) && possible_king_check?(coordinate: end_coordinate)
      return show_invalid_input(error_code: 7)
    end

    # if king in check -> next move must remove the check condition
    if start_piece.valid_move?(start_coordinate: start_coordinate, end_coordinate: end_coordinate, board: @board)
      move_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate)
      return undo_move_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate) if king_in_check?
    elsif start_piece.valid_take?(start_coordinate: start_coordinate, end_coordinate: end_coordinate, board: @board)
      take_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate)
      return undo_take_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate) if king_in_check?
    else
      return show_invalid_input(error_code: 5, start_coordinate: start_coordinate, end_coordinate: end_coordinate)
    end
    true
  end

  def move_piece(start_coordinate:, end_coordinate:)
    return move_castle(start_coordinate: start_coordinate, end_coordinate: end_coordinate) if castling?(
      start_coordinate: start_coordinate, end_coordinate: end_coordinate
    )

    piece = start_coordinate[:value]
    piece.add_to_piece_history(piece: start_coordinate[:value], start_id_y: start_coordinate[:id_y], start_id_x: start_coordinate[:id_x],
                               end_id_y: end_coordinate[:id_y], end_id_x: end_coordinate[:id_x])
    piece.refresh_piece_position(id_x: end_coordinate[:id_x], id_y: end_coordinate[:id_y])

    end_coordinate[:tile].content = piece
    start_coordinate[:tile].remove_piece
  end

  def undo_move_piece(start_coordinate:, end_coordinate:)
    piece = end_coordinate[:tile].content
    piece.remove_last_from_piece_history(piece: piece)
    piece.refresh_piece_position(id_x: start_coordinate[:id_x], id_y: start_coordinate[:id_y])

    start_coordinate[:tile].content = piece
    end_coordinate[:tile].remove_piece
    show_invalid_input(error_code: 9)
  end

  def take_piece(start_coordinate:, end_coordinate:)
    taken_piece = end_coordinate[:value]
    add_piece_to_graveyard(taken_piece: taken_piece)

    move_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate)
  end

  def undo_take_piece(start_coordinate:, end_coordinate:)
    taken_piece = restore_last_piece_from_graveyard
    undo_move_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate)
    end_coordinate[:tile].content = taken_piece
    false # return false to stay in the same gameloop
  end

  def castling?(start_coordinate:, end_coordinate:)
    return false unless end_coordinate[:id_y] == start_coordinate[:id_y]

    id_y = start_coordinate[:id_y]
    if start_coordinate[:value].is_a?(Rook)
      rook_piece_st = start_coordinate[:tile]
      king_piece_st = board[id_y, 5]
      return false unless [king_piece_st, rook_piece_st].all? { |tile| tile.content.piece_moves.empty? }
      return true if [4, 6].include?(end_coordinate[:id_x])

    elsif start_coordinate[:value].is_a?(King)
      rook_piece_st = if start_coordinate[:id_x] > end_coordinate[:id_x]
                        board[id_y, 1]
                      else
                        board[id_y, 8]
                      end
      king_piece_st = start_coordinate[:tile]
      return false unless [king_piece_st, rook_piece_st].all? { |tile| tile.content.piece_moves.empty? }
      return true if [3, 7].include?(end_coordinate[:id_x])
    end
    false
  end

  def move_castle(start_coordinate:, end_coordinate:)
    id_y = start_coordinate[:id_y]

    # Assign new coordinations for pieces
    if start_coordinate[:value].is_a?(Rook)
      rook_piece_st = start_coordinate[:tile]
      rook_piece_end = end_coordinate[:tile]
      king_piece_st = board[id_y, 5]

      king_piece_end = if start_coordinate[:id_x] < end_coordinate[:id_x]
                         board[id_y, 3]
                       else
                         board[id_y, 7]
                       end
    else # When king
      rook_piece_st = if start_coordinate[:id_x] > end_coordinate[:id_x]
                        board[id_y, 1]
                      else
                        board[id_y, 8]
                      end
      rook_piece_end = if start_coordinate[:id_x] > end_coordinate[:id_x]
                         board[id_y, 4]
                       else
                         board[id_y, 6]
                       end
      king_piece_st = start_coordinate[:tile]
      king_piece_end = end_coordinate[:tile]
    end

    # Move both pieces
    [[rook_piece_st, rook_piece_end], [king_piece_st, king_piece_end]].each do |set|
      set[0].content.add_to_piece_history(piece: set[0].content, start_id_y: set[0].id_y, start_id_x: set[0].id_x,
                                          end_id_y: set[1].id_y, end_id_x: set[1].id_x)
      set[0].content.refresh_piece_position(id_x: set[1].id_x, id_y: set[1].id_y)
      set[1].content = set[0].content
      set[0].remove_piece
    end
  end

  def add_piece_to_graveyard(taken_piece:)
    @board.graveyard << taken_piece
  end

  def restore_last_piece_from_graveyard
    @board.graveyard.pop
  end
end
