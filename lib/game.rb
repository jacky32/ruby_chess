# frozen_string_literal: false

require_relative 'board'
require_relative 'player'

# main class for the game
class Game
  attr_accessor(:board, :white_player, :black_player)

  def initialize
    start
    process_input
  end

  def start
    @board = Board.new
    puts "Start a new game or load from save? (type \e[35mstart\e[0m or \e[35mload\e[0m)"
    decision = gets.chomp
    return load if decision == 'load'

    choose_players

    @board.generate
  end

  def save() end

  def load() end

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

  def process_input
    input = gets.chomp
    return save if input == 'save'

    input_array = input.split(' ')
    return invalid_input unless check_input_format(input_array) && check_input_coordinates(input_array)


  end

  def check_input_format(input_array)
    # check whether the input has 2 elements
    return false unless input_array.size == 2
    # checks whether each element has 2 parts (letter and number)
    return false unless input_array.all? { |element| element.size == 2 }

    true
  end

  def check_input_coordinates(input_array)
    # checks whether each element part is a valid position
    first_coordinate = input_array[0].split('')
    second_coordinate = input_array[1].split('')
    return false unless ('a'..'h').to_a.include?(first_coordinate[0].downcase && second_coordinate[0].downcase)
    return false unless (1..8).to_a.include?(first_coordinate[1].to_i && second_coordinate[1].to_i)

    true
  end

  def invalid_input
    puts 'Invalid input, try c1 c2'
    process_input
  end
end

Game.new