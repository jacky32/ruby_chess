# frozen_string_literal: true

# Module for talking with players and processing inputs
module ProcessInputOutput
  # TODO: Move all input/output to this module
  def process_input
    input = gets.chomp
    return check_single_word_input(input) unless input.include?(' ')

    input_array = input.split(' ')
    return invalid_input unless check_input_format(input_array)

    start_coordinate = coordinate_to_hash(input_array[0].split(''))
    end_coordinate = coordinate_to_hash(input_array[1].split(''))
    return invalid_input unless check_input_coordinates(start_coordinate, end_coordinate)

    { start: start_coordinate, end: end_coordinate }
  end

  # TODO: Make use of this method
  def clear_board
    puts "\e[H\e[2J"
  end

  def show_board
    @board.show_board
  end

  def check_single_word_input(input)
    case input
    when 'save' then save
    when 'graveyard' then show_graveyard
    when 'resign' then resign
    when 'draw' then offer_draw
    when 'help' then show_commands
    else
      invalid_input
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

  def show_invalid_move(start_coordinate:, end_coordinate:)
    puts "Invalid move Y:#{start_coordinate[:id_y]} X:#{start_coordinate[:id_x]} -> Y:#{end_coordinate[:id_y]} X:#{end_coordinate[:id_x]} "
  end

  def invalid_input
    puts 'Invalid input, try c1 c2'
    process_input
  end
end
