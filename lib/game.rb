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

    # choose_players
    @board.generate
    game_loop
  end

  def save() end

  def load() end

  def game_loop
    loop do
      # puts "\e[97m#{@white_player.name}'s\e[0m turn!"
      process_input('white')
      @board.show_board
      break if conditions_met?

      # puts "\e[30m#{@black_player.name}'s\e[0m turn!"
      process_input('black')
      @board.show_board
      break if conditions_met?
    end
  end

  def conditions_met?() end

  def choose_players
    @white_player = Player.new(name_loop('white'), 'white')
    @black_player = Player.new(name_loop('black'), 'black')
  end

  def name_loop(color)
    puts "Choose name for the #{color} player"
    name = gets.chomp
    loop do
      name_valid = check_name_validity(name)
      break if name_valid == true

      puts name_valid
      name = gets.chomp
    end
    name
  end

  def check_name_validity(name)
    return 'Too long, try again' if name.size > 12

    true
  end

  def process_input(color)
    input = gets.chomp
    return check_single_word_input(input, color) unless input.include?(' ')

    input_array = input.split(' ')
    return invalid_input(color) unless check_input_format(input_array)

    start_coordinate = coordinate_to_hash(input_array[0].split(''))
    end_coordinate = coordinate_to_hash(input_array[1].split(''))
    return invalid_input(color) unless check_input_coordinates(start_coordinate, end_coordinate)

    check_input_move(start_coordinate, end_coordinate, color)
  end

  def check_single_word_input(input, color)
    return save if input == 'save'

    invalid_input(color)
  end

  def check_input_move(start_coordinate, end_coordinate, color)
    start_piece = start_coordinate['value']

    return invalid_input(color) if start_piece.nil?

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

  def invalid_input(color)
    puts 'Invalid input, try c1 c2'
    process_input(color)
  end
end

Game.new
