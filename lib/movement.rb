# frozen_string_literal: false

# methods for shared movement
module Movement
  # Bishop movement
  def diagonal_piece_in_way?(start_y:, start_x:, end_y:, end_x:, board:)
    distance = (end_y - start_y).abs
    options = { option_one: { first_cond: end_y > start_y, second_cond: end_x > start_x, first_op: 1, second_op: 1 },
                option_two: { first_cond: end_y > start_y, second_cond: end_x < start_x, first_op: 1, second_op: 0 },
                option_three: { first_cond: end_y < start_y, second_cond: end_x > start_x, first_op: 0, second_op: 1 },
                option_four: { first_cond: end_y < start_y, second_cond: end_x < start_x, first_op: 0, second_op: 0 } }
    return true if diagonal_piece_in_way_check?(start_y: start_y, start_x: start_x, distance: distance,
                                                options: options, board: board)

    false
  end

  def diagonal_piece_in_way_check?(start_y:, start_x:, distance:, options:, board:)
    options.each do |_option, value|
      next unless value[:first_cond] && value[:second_cond]

      1.upto(distance - 1) do |increment|
        id_y = assign_diagonal_id(option: value[:first_op], start_id: start_y, increment: increment)
        id_x = assign_diagonal_id(option: value[:second_op], start_id: start_x, increment: increment)
        return true unless board[id_y][id_x].empty?
      end
    end

    false
  end

  def assign_diagonal_id(option:, start_id:, increment:)
    option == 1 ? start_id + increment : start_id - increment
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

  def generate_diagonal_moves(board:, id_y: @id_y, id_x: @id_x)
    # TODO: Remove dependency on ObjectSpace
    board_pieces = ObjectSpace.each_object(BoardPiece).to_a.select do |tile|
      filter_diagonal_selection(id_y: id_y, id_x: id_x, tile: tile, board: board)
    end
    board_pieces.map { |tile| board[tile.id_y][tile.id_x] }
  end

  def filter_diagonal_selection(id_y:, id_x:, tile:, board:)
    tid_y = tile.id_y
    tid_x = tile.id_x
    valid_diagonal_checks(id_y, id_x, tid_y, tid_x) &&
      within_board_boundaries?({ id_y: tid_y, id_x: tid_x }) &&
      !diagonal_piece_in_way?(start_y: id_y, start_x: id_x, end_y: tid_y, end_x: tid_x, board: board)
  end

  # King movement
  def generate_one_around(board:)
    generated_tiles = []
    (-1..1).to_a.each do |increment_y|
      (-1..1).to_a.each do |increment_x|
        tid_y = @id_y + increment_y
        tid_x = @id_x + increment_x
        generated_tiles << board[tid_y][tid_x] unless filter_one_around(id_y: tid_y, id_x: tid_x, board: board)
      end
    end
    generated_tiles
  end

  def filter_one_around(id_y:, id_x:, board:)
    [id_y, id_x].any? { |a| a > 8 || a < 1 } ||
      (id_y == @id_y && id_x == @id_x) ||
      friendly_on_tile?({ value: board[id_y][id_x].content })
  end

  # Rook movement
  def generate_horizontal_and_vertical_moves(board:)
    options = { option_y_down: { id_y: @id_y - 1, id_x: @id_x, rule_id: @id_y - 1, rule_value: -1 },
                option_y_up: { id_y: @id_y + 1, id_x: @id_x, rule_id: @id_y + 1, rule_value: 1 },
                option_x_down: { id_y: @id_y, id_x: @id_x - 1, rule_id: @id_x - 1, rule_value: -1 },
                option_x_up: { id_y: @id_y, id_x: @id_x + 1, rule_id: @id_x + 1, rule_value: 1 } }
    generated_moves = []
    options.each do |_option, value|
      generated_moves << generate_option_moves(id_y: value[:id_y], id_x: value[:id_x], rule_id: value[:rule_id],
                                               rule_value: value[:rule_value], board: board)
    end
    generated_moves.flatten!
  end

  def generate_option_moves(id_y:, id_x:, rule_id:, rule_value:, board:)
    generated_moves = []
    loop do
      tile = (id_y == @id_y ? board[id_y][rule_id] : board[rule_id][id_x])
      generated_moves << tile if move_checks_passed?(tile)
      break unless (rule_value > 0 ? (rule_id < 9) : (rule_id > 0)) && tile.empty?

      rule_id += rule_value
    end
    generated_moves
  end

  def move_checks_passed?(tile)
    within_board_boundaries?({ id_y: tile.id_y, id_x: tile.id_x })
  end
end
