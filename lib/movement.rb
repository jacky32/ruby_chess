# frozen_string_literal: false

# methods for shared movement
module Movement
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

  def in_neighbouring_column?(start_coordinate, end_coordinate)
    start_x = start_coordinate['id_x']
    end_x = end_coordinate['id_x']
    return true if end_x == start_x + 1 || end_x == start_x - 1

    false
  end

  def valid_move_one_around?(start_y, start_x, end_y, end_x)
    distance_y = end_y - start_y
    distance_x = end_x - start_x
    [-1, 0, 1].include?(distance_y) && [-1, 0, 1].include?(distance_x)
  end

  def generate_y_down
    id_y = @id_y - 1
    loop do
      tile = assign_board[id_y][@id_x]
      @possible_moves << tile if move_checks_passed?(tile)
      break unless id_y > 0 && tile.empty?

      id_y -= 1
    end
  end

  def generate_y_up
    id_y = @id_y + 1
    loop do
      tile = assign_board[id_y][@id_x]
      break unless id_y < 9 && tile.empty?

      id_y += 1
    end
  end

  def generate_x_down
    id_x = @id_x - 1
    loop do
      tile = assign_board[@id_y][id_x]
      @possible_moves << tile if move_checks_passed?(tile)
      break unless id_x > 0 && tile.empty?

      id_x -= 1
    end
  end

  def generate_x_up
    id_x = @id_x + 1
    loop do
      tile = assign_board[@id_y][id_x]
      @possible_moves << tile if move_checks_passed?(tile)
      break unless id_x < 9 && tile.empty?

      id_x += 1
    end
  end
end
