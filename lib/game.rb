# frozen_string_literal: false

require_relative 'board'
require_relative 'player'
require_relative 'translate'
require_relative 'process_input_output'

# main class for the game
class Game
  attr_reader :board

  include ProcessInputOutput
  include Translate

  def initialize
    clear_board
    @board = Board.new
  end

  def start
    # puts "Start a new game or load from save? (type \e[35mstart\e[0m or \e[35mload\e[0m)"
    # decision = gets.chomp
    # return load if decision == 'load'

    generate_players
    @board.populate
    show_board
    game_loop
  end

  def save() end

  def load() end

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
      break if conditions_met?

      # switch_current_player
    end
  end

  def switch_current_player
    @current_player = @current_player == @white_player ? @black_player : @white_player
  end

  def conditions_met?() end

  def generate_players
    @white_player = Player.new('white')
    @black_player = Player.new('black')
  end

  def decide_piece_move(start_coordinate:, end_coordinate:)
    start_piece = start_coordinate[:value]

    if start_piece.valid_move?(start_coordinate: start_coordinate, end_coordinate: end_coordinate, board: @board)
      move_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate)
    elsif start_piece.valid_take?(start_coordinate: start_coordinate, end_coordinate: end_coordinate, board: @board)
      take_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate)
    else
      show_invalid_input(error_code: 5, start_coordinate: start_coordinate, end_coordinate: end_coordinate)
      return false
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

  def take_piece(start_coordinate:, end_coordinate:)
    taken_piece = end_coordinate[:value]
    add_piece_to_graveyard(taken_piece: taken_piece)

    move_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate)
  end

  def move_castle(start_coordinate:, end_coordinate:)
    id_y = start_coordinate[:id_y]
    if start_coordinate[:value].is_a?(Rook)
      rook_piece_st = start_coordinate[:tile]
      rook_piece_end = end_coordinate[:tile]
      king_piece_st = board[id_y, 5]

      king_piece_end = board[id_y, 3] if start_coordinate[:id_x] < end_coordinate[:id_x]
      king_piece_end = board[id_y, 7] if start_coordinate[:id_x] > end_coordinate[:id_x]
    elsif start_coordinate[:value].is_a?(King)
      rook_piece_st = board[id_y, 1] if start_coordinate[:id_x] > end_coordinate[:id_x]
      rook_piece_st = board[id_y, 8] if start_coordinate[:id_x] < end_coordinate[:id_x]
      rook_piece_end = board[id_y, 4] if start_coordinate[:id_x] > end_coordinate[:id_x]
      rook_piece_end = board[id_y, 6] if start_coordinate[:id_x] < end_coordinate[:id_x]
      king_piece_st = start_coordinate[:tile]
      king_piece_end = end_coordinate[:tile]
    end

    rook_piece_st.content.add_to_piece_history(piece: rook_piece_st.content, start_id_y: rook_piece_st.id_y, start_id_x: rook_piece_st.id_x,
                                               end_id_y: rook_piece_end.id_y, end_id_x: rook_piece_end.id_x)
    rook_piece_st.content.refresh_piece_position(id_x: rook_piece_end.id_x, id_y: rook_piece_end.id_y)
    rook_piece_end.content = rook_piece_st.content
    rook_piece_st.remove_piece

    king_piece_st.content.add_to_piece_history(piece: king_piece_st.content, start_id_y: king_piece_st.id_y, start_id_x: king_piece_st.id_x,
                                               end_id_y: king_piece_end.id_y, end_id_x: king_piece_end.id_x)
    king_piece_st.content.refresh_piece_position(id_x: king_piece_end.id_x, id_y: king_piece_end.id_y)
    king_piece_end.content = king_piece_st.content
    king_piece_st.remove_piece

    # piece.add_to_piece_history(start_id_y: start_coordinate[:id_y], start_id_x: start_coordinate[:id_x],
    #                            end_id_y: end_coordinate[:id_y], end_id_x: end_coordinate[:id_x])
    # piece.refresh_piece_position(id_x: end_coordinate[:id_x], id_y: end_coordinate[:id_y])

    # end_coordinate[:tile].content = piece
    # start_coordinate[:tile].remove_piece
  end

  def castling?(start_coordinate:, end_coordinate:)
    return false unless end_coordinate[:id_y] == start_coordinate[:id_y]

    if start_coordinate[:value].is_a?(Rook)
      return true if end_coordinate[:id_x] == 4 || end_coordinate[:id_x] == 6
    elsif start_coordinate[:value].is_a?(King)
      return true if end_coordinate[:id_x] == 7 || end_coordinate[:id_x] == 3
    else
      false
    end
  end

  def add_piece_to_graveyard(taken_piece:)
    @board.graveyard << taken_piece
  end
end
