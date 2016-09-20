require_relative 'piece'

class Board
  STARTING_POSITIONS = [
    {B: [2,5], R: [0,7], N: [1,6], Q: [3], K: [4]},
    {P: [0,1,2,3,4,5,6,7]}
  ]
  attr_reader :grid

  def self.new_game
    board = Board.new
    Piece.setup(board)
    board
  end

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
  end

  def dup
    new_board = Board.new

    @grid.each do |row|
      row.each do |piece|
        piece.dup(new_board) unless piece.is_a?(NullPiece)
      end
    end

    new_board
  end

  def move(start, end_pos, color)
    piece = self[start]

    if piece.is_a?(NullPiece)
      raise MoveError.new("Please select a piece.")
    elsif piece.color != color
      raise MoveError.new("Don't move your opponent's pieces!")
    elsif !piece.open_moves.include?(end_pos)
      raise MoveError.new("Not a valid move.")
    end

    self[end_pos] = piece
    piece.position = end_pos
    self[start] = NullPiece.instance
  end

  def in_check?(color)
    king_position = find_king(color)

    opp_color = color == :red ? :white : :red

    find_pieces(opp_color).any? do |piece|
      piece.open_moves.include?(king_position)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)
    find_pieces(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def over?
    checkmate?(:red) || checkmate?(:white)
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

class MoveError < StandardError
end
