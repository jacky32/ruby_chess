# frozen_string_literal: false

# class for each player
class Player
  attr_accessor(:name, :color)

  def initialize(color)
    @color = color
    @name = name_loop
  end

  def name_loop
    puts "Choose name for the #{@color} player"
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
end
