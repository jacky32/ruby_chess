# frozen_string_literal: false

# module for translating letter to numbers
module Translate
  def self.letter_to_number(letter:)
    letters_in_numbers = {}
    ('a'..'h').each_with_index { |lett, numb| letters_in_numbers[lett] = numb + 1 }
    letters_in_numbers[letter.downcase]
  end

  def self.number_to_letter(number:)
    numbers_in_letters = {}
    ('a'..'h').each_with_index { |lett, numb| numbers_in_letters[numb + 1] = lett }
    numbers_in_letters[number]
  end

  def self.coordinate_to_hash(coordinate:, board:)
    id_x = Translate.letter_to_number(letter: coordinate[0])
    id_y = 9 - coordinate[1].to_i
    { id_x: id_x,
      id_y: id_y,
      tile: board[id_y, id_x],
      value: board[id_y, id_x].content }
  end
end
