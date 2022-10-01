# frozen_string_literal: true

# Module for talking with players and processing inputs
module ProcessInputOutput
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

  def check_single_word_input(input)
    case input
    when 'save' then save
    when 'graveyard' then show_graveyard
    else
      invalid_input
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
    return false unless (1..8).to_a.include?(start_coordinate[:id_x] && end_coordinate[:id_x])
    return false unless (1..8).to_a.include?(start_coordinate[:id_y] && end_coordinate[:id_y])

    true
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

  def invalid_input
    puts 'Invalid input, try c1 c2'
    process_input
  end
end
