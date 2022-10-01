module PieceSpecHelper
  def create_coordinate(id_y, id_x)
    {
      id_x: id_x,
      id_y: id_y,
      tile: @board.board[id_y][id_x],
      value: @board[id_y, id_x]
    }
  end

  def create_piece(board:, id_y:, id_x:, type:, color:)
    board.board[id_y][id_x].generate_piece(type, color, { id_y: id_y, id_x: id_x })
  end
end
