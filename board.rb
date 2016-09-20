require_relative 'piece'

class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
  end

  # ADD BOARD.DUP METHOD!

  def move(start, end_pos)
    if self[start].is_a?(NullPiece) || !self[end_pos].is_a?(NullPiece)
      raise "Invalid move"
    end

    self[end_pos] = self[start]
    self[start] = NullPiece.instance
  end

  def in_check?(color)
    king_position = find_king(color)

    opp_color = color == :red ? :white : :red

    find_pieces(opp_color).any? do |piece|
      piece.valid_moves.include?(king_position)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)
    find_pieces(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def find_king(color)
    @grid.each do |row|
      row.each do |piece|
        return piece.position if piece.symbol == :K && piece.color == color
      end
    end
  end

  def find_pieces(color)
    pieces = []

    @grid.each do |row|
      row.each do |piece|
        pieces << piece if piece.color == color
      end
    end

    pieces
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
