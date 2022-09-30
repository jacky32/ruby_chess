# frozen_string_literal: false

require_relative 'board'
require_relative 'player'
require_relative 'translate'

# main class for the game
class Game
  attr_accessor(:board, :white_player, :black_player)

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
      process_input
      @board.show_board
      break if conditions_met?

      switch_current_player
    end
  end

  def switch_current_player
    @current_player = @current_player == @white_player ? @black_player : @white_player
  end

  # TODO: Fix colors
  def show_player_turn_message
    if @current_player == @white_player
      puts "\e[97m#{@white_player.name}'s\e[0m turn!"
    else
      puts "\e[30m#{@black_player.name}'s\e[0m turn!"
    end
  end

  def conditions_met?() end

  def generate_players
    @white_player = Player.new('white')
    @black_player = Player.new('black')
  end

  def process_input
    input = gets.chomp
    return check_single_word_input(input) unless input.include?(' ')

    input_array = input.split(' ')
    return invalid_input unless check_input_format(input_array)

    start_coordinate = coordinate_to_hash(input_array[0].split(''))
    end_coordinate = coordinate_to_hash(input_array[1].split(''))
    return invalid_input unless check_input_coordinates(start_coordinate, end_coordinate)

    check_input_move(start_coordinate, end_coordinate)
  end

  def check_single_word_input(input)
    case input
    when 'save' then save
    when 'graveyard' then graveyard
    else
      invalid_input
    end
  end

  def graveyard
    @board.graveyard.each_with_index { |dead, index| puts "#{index + 1}. #{dead[1]} #{dead[0]}" }
  end

  def check_input_move(start_coordinate, end_coordinate)
    start_piece = start_coordinate['value']

    return invalid_input if start_piece.nil?

    # TODO: move logic to pieces
    if start_piece.valid_move?(start_coordinate, end_coordinate)
      start_piece.move(start_coordinate, end_coordinate)
    elsif start_piece.valid_take?(start_coordinate, end_coordinate)
      start_piece.take(start_coordinate, end_coordinate, @board)
    else
      puts 'Invalid move'
    end
  end

  def check_input_format(input_array)
    # check whether the input has 2 elements
    return false unless input_array.size == 2
    # checks whether each element has 2 parts (letter and number)
    return false unless input_array.all? { |element| element.size == 2 }

    true
  end

  def check_input_coordinates(start_coordinate, end_coordinate)
    # checks whether each element part is a valid position
    return false unless (1..8).to_a.include?(start_coordinate['id_x'] && end_coordinate['id_x'])
    return false unless (1..8).to_a.include?(start_coordinate['id_y'] && end_coordinate['id_y'])

    true
  end

  def invalid_input
    puts 'Invalid input, try c1 c2'
    process_input
  end
end

Game.new
