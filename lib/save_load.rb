require 'json'

module SaveLoad
  private

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')

    filename = generate_filename
    File.open("saves/#{filename}.json", 'w') do |save_file|
      save_file.puts as_json
    end
  end

  def generate_filename
    name_part = "#{@white_player.name}_#{@black_player.name}"
    date_part = Time.now.strftime('%d_%m_%Y_%H-%M-%S_')
    date_part + name_part
  end

  def as_json
    JSON.dump({
                board: board_as_json(@board),
                white_player: player_as_json(@white_player),
                black_player: player_as_json(@black_player),
                current_player: player_as_json(@current_player)
              })
  end

  def board_as_json(board)
    {
      graveyard: board.graveyard,
      board: get_pieces(board)
    }
  end

  def get_pieces(board)
    pieces = {}
    count = 0
    board.board.each_with_index do |row, id_y|
      row.each_with_index do |_tile, id_x|
        pieces[count] = board_piece_as_json(board[id_y, id_x])
        count += 1
      end
    end
    pieces
  end

  def board_piece_as_json(board_piece)
    {
      board_piece: {
        id_y: board_piece.id_y,
        id_x: board_piece.id_x,
        color: board_piece.color,
        content: piece_as_json(board_piece.content)
      }
    }
  end

  def piece_as_json(piece)
    return nil if piece.nil?

    {
      piece_color: piece.piece_color,
      piece_moves: piece.piece_moves,
      id_y: piece.id_y,
      id_x: piece.id_x
    }
  end

  def player_as_json(player)
    {
      name: player.name,
      color: player.color
    }
  end

  def load() end
end
