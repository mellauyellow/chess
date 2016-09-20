require_relative '../piece'
require_relative './sliding'

class Queen < Piece
  include SlidingPiece
  def self.setup(board)
    [[0,3],[7,3]].each do |pos|
      color = pos[0] == 0 ? :black : :white
      Queen.new(pos, board, color)
    end
  end
  def initialize(position, board, color)
    @symbol = (color == :black) ? "\u265B" : "\u2655"
    super
  end

  def move_dirs
    [[1,0],[0,1],[-1,0],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]
  end
end
