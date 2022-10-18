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
        processed = decide_piece_move(start_coordinate: coordinates[:start], end_coordinate: coordinates[:end])
      end
      break if conditions_met?

      switch_current_player
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
    piece = start_coordinate[:value]
    piece.add_to_piece_history(start_coordinate, end_coordinate)
    piece.refresh_piece_position(end_coordinate)

    end_coordinate[:tile].content = piece
    start_coordinate[:tile].remove_piece
  end

  def take_piece(start_coordinate:, end_coordinate:)
    taken_piece = end_coordinate[:value]
    add_piece_to_graveyard(taken_piece: taken_piece)

    move_piece(start_coordinate: start_coordinate, end_coordinate: end_coordinate)
  end

  def add_piece_to_graveyard(taken_piece:)
    @board.graveyard << taken_piece
  end
end
