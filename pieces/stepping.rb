module SteppingPiece
  def moves
    move_list = []

    move_diffs.each do |diff|
      new_row = diff[0] + @position[0]
      new_col = diff[1] + @position[1]
      move_list << [new_row, new_col]
    end

    move_list
  end
end
