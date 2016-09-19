require_relative 'piece'

class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
  end

  def move(start, end_pos)
    if self[start].is_a?(NullPiece) || !self[end_pos].is_a?(NullPiece)
      raise "Invalid move"
    end

    self[end_pos] = self[start]
    self[start] = NullPiece.instance
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def in_bounds?(pos)
    pos.all? { |el| el.between?(0,7) }
  end

  protected

  def _make_starting_grid
    #will add after Piece class done
  end
end
