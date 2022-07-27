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
      break if conditions_met?

      # puts "\e[30m#{@black_player.name}'s\e[0m turn!"
      process_input('black')
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
    return save if input == 'save'

    input_array = input.split(' ')
    first_coordinate = input_array[0].split('')
    second_coordinate = input_array[1].split('')
    return invalid_input unless check_input_format(input_array) && check_input_coordinates(first_coordinate, second_coordinate)

    check_input_move(first_coordinate, second_coordinate)
    @board.show_board
  end

  def check_input_move(first_coordinate, second_coordinate)
    # check piece if valid move

    id_x1 = translate_letter_to_number(first_coordinate[0])
    id_y1 = 9 - first_coordinate[1].to_i
    id_x2 = translate_letter_to_number(second_coordinate[0])
    id_y2 = 9 - second_coordinate[1].to_i
    first_piece = @board.board[id_y1][id_x1].content
    if first_piece.valid_move?(id_y1, id_x1, id_y2, id_x2, @board)
      first_piece.move(id_y1, id_x1, id_y2, id_x2, @board)
    elsif first_piece.valid_take?(id_y1, id_x1, id_y2, id_x2, @board)
      first_piece.take(id_y1, id_x1, id_y2, id_x2, @board)
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

  def check_input_coordinates(first_coordinate, second_coordinate)
    # checks whether each element part is a valid position
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
