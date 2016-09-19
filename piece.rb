require 'singleton'

class Piece
  attr_reader :symbol, :color
  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
  end

  def valid_moves
    moves.reject { |move| move.all? { |pos| pos.between?(0, 7) } }
  end
end

class NullPiece
  include Singleton
  attr_reader :symbol
  def initialize
    @symbol = ' '
  end
end

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
    end

    unblocked
  end
end

class Bishop < Piece
  include SlidingPiece
  def initialize(position, board, color)
    @symbol = :B
    super
  end

  def move_dirs
    [[1,1],[1,-1],[-1,1],[-1,-1]]
  end
end

class Rook < Piece
  include SlidingPiece
  def initialize(position, board, color)
    @symbol = :R
    super
  end

  def move_dirs
    [[1,0],[0,1],[-1,0],[0,-1]]
  end
end

class Queen < Piece
  include SlidingPiece
  def initialize(position, board, color)
    @symbol = :Q
    super
  end

  def move_dirs
    [[1,0],[0,1],[-1,0],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]
  end
end

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

class King < Piece
  include SteppingPiece
  def initialize(position, board, color)
    @symbol = :K
    super
  end

  def move_diffs
    diffs = []
    (-1..1).each do |row|
      (-1..1).each do |col|
        diffs << [row, col]
      end
    end
    diffs
  end
end

class Knight < Piece
  include SteppingPiece
  def initialize(position, board, color)
    @symbol = :N
    super
  end

  def move_diffs
    [[2, 1], [2, -1], [-2, 1],[-2, -1], [1, 2], [1, -2], [-1, 2],[-1, -2]]
  end
end
