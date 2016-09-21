module SlidingPiece
  def moves
    move_list = []
    move_dirs.each do |dir|
      move_list.concat(grow_unblocked_moves(dir))
    end

    move_list
  end

  def grow_unblocked_moves(diff)
    unblocked = []
    dx , dy = diff
    x, y = @position
    new_pos = [x + dx, y + dy]
    until !@board.in_bounds?(new_pos) || @board[new_pos].color == @color
      unblocked << new_pos
      break if enemy?(@board[new_pos])
      new_pos = [new_pos[0] + dx, new_pos[1] + dy]
    end

    # unblocked << new_pos if enemy?(@board[new_pos])
    unblocked
  end

  def blocked?(new_pos)
    !@board.in_bounds?(new_pos) || @board[new_pos].color == @color || enemy?(@board[new_pos])
  end
end
