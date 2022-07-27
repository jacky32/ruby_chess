# frozen_string_literal: false

# module for translating letter to numbers
module Translate
  def translate_letter_to_number(letter)
    letters_in_numbers = {}
    ('a'..'h').each_with_index { |lett, numb| letters_in_numbers[lett] = numb + 1 }
    letters_in_numbers[letter.downcase]
  end

  def translate_number_to_letter(number)
    letters_in_numbers = {}
    ('a'..'h').each_with_index { |lett, numb| letters_in_numbers[numb + 1] = lett }
    letters_in_numbers[number]
  end

  def coordinate_to_hash(coordinate)
    id_x = translate_letter_to_number(coordinate[0])
    id_y = 9 - coordinate[1].to_i
    { 'id_x' => id_x,
      'id_y' => id_y,
      'tile' => @board.board[id_y][id_x],
      'value' => @board.board[id_y][id_x].content }
  end
end
