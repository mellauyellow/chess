require 'singleton'


class Piece
  attr_reader :symbol, :color
  attr_accessor :position, :board
  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
    @board[@position] = self
  end

  def valid_moves
    open_moves.reject do |move|
      move_into_check?(move)
    end
  end

  def open_moves
    moves.select do |move|
      @board.in_bounds?(move) && @board[move].color != @color
    end
  end

  def move_into_check?(end_pos)
    new_board = @board.dup

    new_board.move(@position, end_pos, @color)

    new_board.in_check?(@color)
  end

  def to_s
    "#{self.symbol}"
  end

  def enemy?(piece)
    @color != piece.color && !piece.color.nil?
  end

  def dup(new_board)
    new_pos = @position.dup
    self.class.new(new_pos, new_board, @color)
  end
end

class NullPiece
  include Singleton
  attr_reader :symbol, :color
  def initialize
    @color = nil
  end

  def to_s
    ' '
  end
end
