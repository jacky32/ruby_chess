# frozen_string_literal: false

# class for each player
class Player
  attr_accessor(:name, :color)

  def initialize(color, name = nil)
    @color = color
    @name = name.nil? ? name_loop : name # Goes into the name_loop with color loaded
  end

  def name_loop
    puts "Choose name for the #{@color} player"
    name = gets.chomp
    name = gets.chomp until name_valid?(name)
    name
  end

  def name_valid?(name)
    if name.size > 12
      puts 'Too long, try again'
      return false
    end

    true
  end
end
