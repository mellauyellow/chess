require_relative '../piece'
require_relative './stepping'

class Knight < Piece
  include SteppingPiece
  def self.setup(board)
    [[0,1],[0,6],[7,1],[7,6]].each do |pos|
      color = pos[0] == 0 ? :black : :white
      Knight.new(pos, board, color)
    end
  end
  def initialize(position, board, color)
    @symbol = (color == :black) ? "\u265E" : "\u2658"
    super
  end

  def move_diffs
    [[2, 1], [2, -1], [-2, 1],[-2, -1], [1, 2], [1, -2], [-1, 2],[-1, -2]]
  end
end
