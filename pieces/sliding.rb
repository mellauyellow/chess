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
    new_pos = [@position[0] + dx, @position[1] + dy]
    until !@board.in_bounds?(new_pos) || @board[new_pos].color == @color
      unblocked << new_pos
      new_pos = [new_pos[0] + dx, new_pos[1] + dy]
    end

    unblocked
  end
end
