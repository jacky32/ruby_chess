# frozen_string_literal: false

# class for each player
class Player
  attr_accessor(:name, :color)

  def initialize(name, color)
    @name = name
    @color = color
  end
end
