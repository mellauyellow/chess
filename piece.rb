require 'singleton'
require 'byebug'

class Piece
  def self.setup(board)
    Pawn.setup(board)
    Knight.setup(board)
    Rook.setup(board)
    Queen.setup(board)
    Bishop.setup(board)
    King.setup(board)
  end

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
    "#{self.symbol}".colorize(self.color)
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

class Bishop < Piece
  include SlidingPiece
  def self.setup(board)
    [[0,2],[0,5],[7,2],[7,5]].each do |pos|
      color = pos[0] == 0 ? :red : :white
      Bishop.new(pos, board, color)
    end
  end
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
  def self.setup(board)
    [[0,0],[0,7],[7,0],[7,7]].each do |pos|
      color = pos[0] == 0 ? :red : :white
      Rook.new(pos, board, color)
    end
  end
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
  def self.setup(board)
    [[0,3],[7,3]].each do |pos|
      color = pos[0] == 0 ? :red : :white
      Queen.new(pos, board, color)
    end
  end
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
  def self.setup(board)
    [[0,4],[7,4]].each do |pos|
      color = pos[0] == 0 ? :red : :white
      King.new(pos, board, color)
    end
  end
  def initialize(position, board, color)
    @symbol = :K
    super
  end

  def move_diffs
    diffs = []
    (-1..1).each do |row|
      (-1..1).each do |col|
        diffs << [row, col] unless [row, col] == [0,0]
      end
    end
    diffs
  end
end

class Knight < Piece
  include SteppingPiece
  def self.setup(board)
    [[0,1],[0,6],[7,1],[7,6]].each do |pos|
      color = pos[0] == 0 ? :red : :white
      Knight.new(pos, board, color)
    end
  end
  def initialize(position, board, color)
    @symbol = :N
    super
  end

  def move_diffs
    [[2, 1], [2, -1], [-2, 1],[-2, -1], [1, 2], [1, -2], [-1, 2],[-1, -2]]
  end
end

class Pawn < Piece
  def self.setup(board)
    (0..7).each do |col|
      Pawn.new([1, col], board, :red)
      Pawn.new([6, col], board, :white)
    end
  end

  def initialize(position, board, color)
    @symbol = :P
    super
    @start_row = @position[0]
  end

  def moves
    forward_steps + side_attacks
  end

  def forward_steps
    diff = forward_dir

    # debugger
    pos_x, pos_y = @position
    if at_start_row?
      possible_moves = [[pos_x + forward_dir, pos_y], [pos_x + forward_dir * 2, pos_y]]
      possible_moves.select { |move| !enemy?(@board[move]) }
    else
      possible_move = [[pos_x + forward_dir, pos_y]]
      possible_move unless enemy?(@board[possible_move[0]])
    end
  end

  def side_attacks
    pos_x, pos_y = @position

    if forward_dir == 1
      possible_moves = [[pos_x + 1, pos_y + 1], [pos_x + 1, pos_y - 1]]
      possible_moves.select! { |move| @board.in_bounds?(move) }
      possible_moves.select { |move| enemy?(@board[move]) }
    else
      possible_moves = [[pos_x - 1, pos_y - 1], [pos_x - 1, pos_y + 1]]
      possible_moves.select! { |move| @board.in_bounds?(move) }
      possible_moves.select { |move| enemy?(@board[move]) }
    end
  end

  def at_start_row?
    @position[0] == @start_row
  end

  def forward_dir
    @color == :red ? 1 : -1
  end
end
