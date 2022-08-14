# frozen_string_literal: false

module Movement
  def move(start_coordinate, end_coordinate)
    add_to_piece_history(start_coordinate, end_coordinate)
    refresh_piece_position(end_coordinate)
    end_coordinate['tile'].content = start_coordinate['value']
    start_coordinate['tile'].remove_piece
  end

  def take(start_coordinate, end_coordinate, board)
    add_to_graveyard(end_coordinate['value'], board)
    move(start_coordinate, end_coordinate)
  end

  def add_to_piece_history(start_coordinate, end_coordinate)
    start_coordinate['value'].piece_moves << [
      [start_coordinate['id_y'], translate_number_to_letter(start_coordinate['id_x'])],
      [end_coordinate['id_y'], translate_number_to_letter(end_coordinate['id_x'])]
    ]
  end

  def refresh_piece_position(coordinate)
    @id_y = coordinate['id_y']
    @id_x = coordinate['id_x']
  end

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

  def valid_cross_take?(start_coordinate, end_coordinate)
    start_y = start_coordinate['id_y']
    end_y = end_coordinate['id_y']
    return false unless enemy_on_tile?(end_coordinate)
    return false unless in_neighbouring_column?(start_coordinate, end_coordinate)

    if @piece_color == 'white'
      return false unless end_y == start_y - 1
    else
      return false unless end_y == start_y + 1
    end

    true
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
end
