# frozen_string_literal: false

# module for translating letter to numbers
module Translate
  def translate_letter_to_number(letter)
    letters_in_numbers = {}
    ('a'..'h').each_with_index { |lett, numb| letters_in_numbers[lett] = numb + 1 }
    letters_in_numbers[letter]
  end

  def translate_number_to_letter(number)
    letters_in_numbers = {}
    ('a'..'h').each_with_index { |lett, numb| letters_in_numbers[numb + 1] = lett }
    letters_in_numbers[number]
  end
end
