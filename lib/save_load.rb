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
        content: piece_as_json(board_piece.content)
      }
    }
  end

  def piece_as_json(piece)
    return nil if piece.nil?

    {
      type: piece.class,
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

  def load_game
    return show_invalid_input(error_code: 6) unless Dir.exist?('saves')

    save = get_save
    return false if save == false

    save_data = JSON.parse(File.read("saves/#{save}"))

    load_from_json(save_data)

    true
  end

  def load_from_json(data)
    @board.graveyard = data['board']['graveyard']
    @white_player = Player.new('white', data['white_player']['name'])
    @black_player = Player.new('black', data['black_player']['name'])

    load_board_pieces_from_json(data['board']['board'])
  end

  def load_board_pieces_from_json(board)
    p board
    board.each_value do |i|
      id_y = i['board_piece']['id_y'].to_i
      id_x = i['board_piece']['id_x'].to_i
      content = load_piece_from_json(i['board_piece']['content'])
      @board[id_y, id_x].content = content
    end
  end

  def load_piece_from_json(piece)
    return nil if piece.nil?

    piece_color = piece['piece_color']
    piece_position = { id_y: piece['id_y'].to_i, id_x: piece['id_x'].to_i }

    loaded_piece = case piece['type'].downcase
                   when 'pawn' then Pawn.new(piece_color: piece_color, piece_position: piece_position)
                   when 'knight' then Knight.new(piece_color: piece_color, piece_position: piece_position)
                   when 'rook' then Rook.new(piece_color: piece_color, piece_position: piece_position)
                   when 'bishop' then Bishop.new(piece_color: piece_color, piece_position: piece_position)
                   when 'queen' then Queen.new(piece_color: piece_color, piece_position: piece_position)
                   when 'king' then King.new(piece_color: piece_color, piece_position: piece_position)
                   end
    loaded_piece.piece_moves = piece['piece_moves']
    loaded_piece
  end

  def get_save
    save_files = Dir.children('saves').sort.reverse.first(5)
    puts "Choose which save file to load or type 'end' to start a new game:"
    save_files.each_with_index { |name, i| puts "#{i + 1}: #{name[0..-6]}" }

    file_option = ''
    loop do
      file_option = gets.chomp
      break if (1..save_files.count).to_a.any?(file_option.to_i)
      return false if file_option.downcase == 'end'

      puts 'Invalid option! Try again by entering a number:'
    end
    save_files[file_option.to_i - 1]
  end
end
