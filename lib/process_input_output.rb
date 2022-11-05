# frozen_string_literal: true

# Module for talking with players and processing inputs
module ProcessInputOutput
  def load?
    puts "Start a new game or load from save? (type \e[35mstart\e[0m or \e[35mload\e[0m)"
    decision = gets.chomp
    return load_game if decision == 'load'

    false
  end

  def process_input
    input = gets.chomp
    return check_single_word_input(input) unless input.include?(' ')

    input_array = input.split(' ')
    return show_invalid_input(error_code: 9) unless check_input_format(input_array)

    start_coordinate = coordinate_to_hash(input_array[0].split(''))
    end_coordinate = coordinate_to_hash(input_array[1].split(''))
    return show_invalid_input(error_code: 2) unless check_input_coordinates(start_coordinate, end_coordinate)
    return show_invalid_input(error_code: 1) unless check_valid_start_piece(start_coordinate: start_coordinate)
    return show_invalid_input(error_code: 0) unless check_player(start_coordinate: start_coordinate)

    { start: start_coordinate, end: end_coordinate }
  end

  # TODO: Make use of this method
  def clear_board
    puts "\e[H\e[2J"
  end

  def show_board
    @board.show_board
  end

  def check_valid_start_piece(start_coordinate:)
    !start_coordinate[:value].nil?
  end

  def check_player(start_coordinate:, current_player: @current_player)
    start_coordinate[:value].piece_color == current_player.color
  end

  def check_single_word_input(input)
    case input
    when 'save' then save_game
    when 'graveyard' then show_graveyard
    when 'resign' then resign
    when 'draw' then offer_draw
    when 'help' then show_commands
    else
      show_invalid_input(error_code: 9)
    end
  end

  def show_commands
    puts ''
    puts 'You can use the following commands:'
    puts 'help - lists all commands'
    puts 'save - saves the game'
    puts 'draw - offers a draw'
    puts 'resign - resigns'
    puts 'graveyard - lists the dead pieces' # TODO: Maintain
    puts ''
    puts ''
  end

  def offer_draw
    # TODO: Add functionality
  end

  def resign
    # TODO: Add functionality
  end

  # TODO: List all past moves on the side of the board?

  def check_input_format(input_array)
    # check whether the input has 2 elements
    return false unless input_array.size == 2
    # checks whether each element has 2 parts (letter and number)
    return false unless input_array.all? { |element| element.size == 2 }

    true
  end

  def check_input_coordinates(start_coordinate, end_coordinate)
    # checks whether each element part is a valid position
    return false unless (1..8).to_a.include?(start_coordinate[:id_x] && end_coordinate[:id_x])
    return false unless (1..8).to_a.include?(start_coordinate[:id_y] && end_coordinate[:id_y])

    true
  end

  def show_gameloop
    clear_board
    show_board
    show_player_turn_message
  end

  # TODO: Fix colors
  def show_player_turn_message
    if @current_player == @white_player
      puts "\e[97m#{@white_player.name}'s\e[0m turn!"
    else
      puts "\e[30m#{@black_player.name}'s\e[0m turn!"
    end
  end

  # TODO: print dead pieces on the side of the board
  def show_graveyard
    @board.graveyard.each_with_index { |dead, index| puts "#{index + 1}. #{dead[1]} #{dead[0]}" }
  end

  def show_invalid_input(error_code:, start_coordinate: nil, end_coordinate: nil)
    case error_code
    when 0 then puts "Not your piece! It's #{@current_player.name}'s move."
    when 1 then puts 'You selected an empty board piece! Try again.'
    when 2 then puts 'Selected input is out of the board boundaries! Try again.'
    when 4 then puts 'Invalid input'
    when 5 then puts "Invalid move! Selected piece cannot move from #{translate_number_to_letter(start_coordinate[:id_x])}#{9 - start_coordinate[:id_y]} to #{translate_number_to_letter(end_coordinate[:id_x])}#{9 - end_coordinate[:id_y]}"
    when 6 then puts 'No saves exist! Starting new game'
    when 7 then puts 'King would be in check! Choose a different move'
    else puts "Invalid input, try 'c1 c2' or 'help'"
    end

    false
  end
end
