require './lib/translate'
require './lib/board'

describe Translate do
  context 'Translate.letter_to_number' do
    it 'returns 1 when given a' do
      result = Translate.letter_to_number(letter: 'a')
      expect(result).to eq(1)
    end
    it 'returns 2 when given b' do
      result = Translate.letter_to_number(letter: 'b')
      expect(result).to eq(2)
    end
    it 'returns 8 when given h' do
      result = Translate.letter_to_number(letter: 'h')
      expect(result).to eq(8)
    end
  end

  context 'Translate.number_to_letter' do
    it 'returns a when given 1' do
      result = Translate.number_to_letter(number: 1)
      expect(result).to eq('a')
    end
    it 'returns b when given 2' do
      result = Translate.number_to_letter(number: 2)
      expect(result).to eq('b')
    end
    it 'returns h when given 8' do
      result = Translate.number_to_letter(number: 8)
      expect(result).to eq('h')
    end
  end

  context 'Translate.coordinate_to_hash' do
    it 'returns a coordinate when given a1' do
      coordinate = %w[a 1]
      board = Board.new
      piece = board[8, 1].generate_piece('rook', 'white', { id_y: 8, id_x: 1 })
      board_piece = board[8, 1]

      result = Translate.coordinate_to_hash(coordinate: coordinate, board: board)
      expect(result[:id_y]).to eq(8)
      expect(result[:id_x]).to eq(1)
      expect(result[:tile]).to eq(board_piece)
      expect(result[:value]).to eq(piece)
    end
  end
end
