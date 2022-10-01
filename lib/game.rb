# frozen_string_literal: false

require_relative 'board'
require_relative 'player'
require_relative 'translate'
require_relative 'process_input_output'

# main class for the game
class Game
  attr_accessor(:board, :white_player, :black_player)

  include ProcessInputOutput
  include Translate

  def initialize
    start
  end

  def start
    @board = Board.new
    # puts "Start a new game or load from save? (type \e[35mstart\e[0m or \e[35mload\e[0m)"
    # decision = gets.chomp
    # return load if decision == 'load'

    generate_players
    @board.generate
    game_loop
  end

  def save() end

  def load() end

  def game_loop
    @current_player = @white_player
    loop do
      show_player_turn_message
      coordinates = process_input
      decide_piece_move(coordinates[:start], coordinates[:end])
      @board.show_board
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

  # def check_input_move(start_coordinate, end_coordinate)
  #   start_piece = start_coordinate[:value]

  #   return invalid_input if start_piece.nil?

  #   # TODO: move logic to pieces
  #   if start_piece.valid_move?(start_coordinate, end_coordinate)
  #     move_piece(start_coordinate, end_coordinate)
  #   elsif start_piece.valid_take?(start_coordinate, end_coordinate)
  #     take_piece(start_coordinate, end_coordinate, @board)
  #   else
  #     puts 'Invalid move'
  #   end
  # end

  def decide_piece_move(start_coordinate, end_coordinate)
    start_piece = start_coordinate[:value]

    return invalid_input if start_piece.nil?

    # TODO: move logic to pieces
    if start_piece.valid_move?(start_coordinate, end_coordinate)
      move_piece(start_coordinate, end_coordinate)
    elsif start_piece.valid_take?(start_coordinate, end_coordinate)
      take_piece(start_coordinate, end_coordinate)
    else
      puts 'Invalid move'
    end
  end

  def move_piece(start_coordinate, end_coordinate)
    piece = start_coordinate[:value]
    piece.add_to_piece_history(start_coordinate, end_coordinate)
    piece.refresh_piece_position(end_coordinate)

    end_coordinate[:tile].content = piece
    start_coordinate[:tile].remove_piece
  end

  def take_piece(start_coordinate, end_coordinate)
    taken_piece = end_coordinate[:value]
    add_piece_to_graveyard(taken_piece)

    move_piece(start_coordinate, end_coordinate)
  end

  def add_piece_to_graveyard(piece)
    @board.graveyard << piece
  end
end

Game.new
