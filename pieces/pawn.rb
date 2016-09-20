require_relative '../piece'

class Pawn < Piece
  def self.setup(board)
    (0..7).each do |col|
      Pawn.new([1, col], board, :black)
      Pawn.new([6, col], board, :white)
    end
  end

  def initialize(position, board, color)
    @symbol = (color == :black) ? "\u265F" : "\u2659"
    super
    @start_row = @position[0]
  end

  def moves
    forward_steps + side_attacks
  end

  def forward_steps
    pos_x, pos_y = @position
    if at_start_row?
      p_moves = [[pos_x + f_dir, pos_y], [pos_x + f_dir * 2, pos_y]]
      valid_forward_moves(p_moves)
    else
      p_moves = [[pos_x + f_dir, pos_y]]
      valid_forward_moves(p_moves)
    end
  end

  def side_attacks
    pos_x, pos_y = @position

    if f_dir == 1
      p_moves = [[pos_x + 1, pos_y + 1], [pos_x + 1, pos_y - 1]]
      valid_side_attacks(p_moves)
    else
      p_moves = [[pos_x - 1, pos_y - 1], [pos_x - 1, pos_y + 1]]
      valid_side_attacks(p_moves)
    end
  end

  def at_start_row?
    @position[0] == @start_row
  end

  def valid_forward_moves(moves)
    moves.select do |move|
      @board.in_bounds?(move) && !enemy?(@board[move])
    end
  end

  def valid_side_attacks(moves)
    moves.select do |move|
      @board.in_bounds?(move) && enemy?(@board[move])
    end
  end

  def f_dir
    @color == :black ? 1 : -1
  end
end
