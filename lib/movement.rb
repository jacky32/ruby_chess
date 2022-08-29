# frozen_string_literal: false

# methods for shared movement
module Movement
  # Bishop movement
  def diagonal_piece_in_way?(start_y, start_x, end_y, end_x)
    distance = (end_y - start_y).abs

    return true if [
      diagonal_piece_bottom_right?(distance, start_y, start_x, end_y, end_x),
      diagonal_piece_bottom_left?(distance, start_y, start_x, end_y, end_x),
      diagonal_piece_up_right?(distance, start_y, start_x, end_y, end_x),
      diagonal_piece_up_left?(distance, start_y, start_x, end_y, end_x)
    ].any?(true)

    false
  end

  def diagonal_piece_bottom_right?(distance, start_y, start_x, end_y, end_x)
    if end_y > start_y && end_x > start_x
      1.upto(distance - 1) do |increment|
        return true unless assign_board[start_y + increment][start_x + increment].empty?
      end
    end

    false
  end

  def diagonal_piece_bottom_left?(distance, start_y, start_x, end_y, end_x)
    if end_y > start_y && end_x < start_x
      1.upto(distance - 1) do |increment|
        return true unless assign_board[start_y + increment][start_x - increment].empty?
      end
    end

    false
  end

  def diagonal_piece_up_right?(distance, start_y, start_x, end_y, end_x)
    if end_y < start_y && end_x > start_x
      1.upto(distance - 1) do |increment|
        return true unless assign_board[start_y - increment][start_x + increment].empty?
      end
    end

    false
  end

  def diagonal_piece_up_left?(distance, start_y, start_x, end_y, end_x)
    if end_y < start_y && end_x < start_x
      1.upto(distance - 1) do |increment|
        return true unless assign_board[start_y - increment][start_x - increment].empty?
      end
    end

    false
  end

  def valid_diagonal_checks(start_y, start_x, end_y, end_x)
    return false unless [
      end_y > start_y && end_x > start_x, # bottom right
      end_y > start_y && end_x < start_x, # bottom left
      end_y < start_y && end_x > start_x, # up right
      end_y < start_y && end_x < start_x # up left
    ].any?(true)

    distance_y = (end_y - start_y).abs
    distance_x = (end_x - start_x).abs

    distance_y == distance_x
  end

  def generate_diagonal_moves(id_y = @id_y, id_x = @id_x)
    board_pieces = ObjectSpace.each_object(BoardPiece).to_a.select do |tile|
      filter_diagonal_selection(id_y, id_x, tile)
    end
    board = assign_board
    board_pieces.map { |tile| board[tile.id_y][tile.id_x] }
  end

  def filter_diagonal_selection(id_y, id_x, tile)
    tid_y = tile.id_y
    tid_x = tile.id_x
    valid_diagonal_checks(id_y, id_x, tid_y, tid_x) &&
      within_board_boundaries?({ 'id_y' => tid_y, 'id_x' => tid_x }) &&
      !diagonal_piece_in_way?(id_y, id_x, tid_y, tid_x)
  end

  # King movement
  def generate_one_around
    board = assign_board
    generated_tiles = []
    (-1..1).to_a.each do |index|
      (-1..1).to_a.each do |index2|
        tid_y = @id_y + index
        tid_x = @id_x + index2
        generated_tiles << board[tid_y][tid_x] unless filter_one_around(tid_y, tid_x, board)
      end
    end
    generated_tiles
  end

  def filter_one_around(tid_y, tid_x, board)
    [tid_y, tid_x].any? { |a| a > 8 || a < 1 } ||
      (tid_y == @id_y && tid_x == @id_x) ||
      friendly_on_tile?({ 'value' => board[tid_y][tid_x].content })
  end

  # Rook movement
  def generate_horizontal_and_vertical_moves
    # generate_y_down + generate_y_up + generate_x_down + generate_x_up
    generator
  end

  def generate_y_down(id_y = @id_y - 1, generated_moves = [])
    loop do
      tile = assign_board[id_y][@id_x]
      generated_moves << tile if move_checks_passed?(tile)
      break unless id_y > 0 && tile.empty?

      id_y -= 1
    end
    generated_moves
  end

  def generator
    options = { option_y_down: { id_y: @id_y - 1, id_x: @id_x, rule_id: 'id_y', rule_value: -1 },
                option_y_up: { id_y: @id_y + 1, id_x: @id_x, rule_id: 'id_y', rule_value: 1 },
                option_x_down: { id_y: @id_y, id_x: @id_x - 1, rule_id: 'id_x', rule_value: -1 },
                option_x_up: { id_y: @id_y, id_x: @id_x + 1, rule_id: 'id_x', rule_value: 1 } }
    generated_moves = []
    options.each do |_option, value|
      id_y = value[:id_y]
      id_x = value[:id_x]
      rule_id = (value[:rule_id] == 'id_y' ? id_y : id_x)
      loop do
        tile = (value[:id_y] == @id_y ? assign_board[id_y][rule_id] : assign_board[rule_id][id_x])
        generated_moves << tile if move_checks_passed?(tile)
        break unless (value[:rule_value] > 0 ? (rule_id < 9) : (rule_id > 0)) && tile.empty?

        rule_id += value[:rule_value]
      end
    end
    generated_moves
  end

  def generate_y_up(id_y = @id_y + 1, generated_moves = [])
    loop do
      tile = assign_board[id_y][@id_x]
      generated_moves << tile if move_checks_passed?(tile)
      break unless id_y < 9 && tile.empty?

      id_y += 1
    end
    generated_moves
  end

  def generate_x_down(id_x = @id_x - 1, generated_moves = [])
    loop do
      tile = assign_board[@id_y][id_x]
      generated_moves << tile if move_checks_passed?(tile)
      break unless id_x > 0 && tile.empty?

      id_x -= 1
    end
    generated_moves
  end

  def generate_x_up(id_x = @id_x + 1, generated_moves = [])
    loop do
      tile = assign_board[@id_y][id_x]
      generated_moves << tile if move_checks_passed?(tile)
      break unless id_x < 9 && tile.empty?

      id_x += 1
    end
    generated_moves
  end

  def move_checks_passed?(tile)
    within_board_boundaries?({ 'id_y' => tile.id_y, 'id_x' => tile.id_x })
  end
end
