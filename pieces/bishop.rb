require_relative '../piece'
require_relative './sliding'

class Bishop < Piece
  include SlidingPiece
  def self.setup(board)
    [[0,2],[0,5],[7,2],[7,5]].each do |pos|
      color = pos[0] == 0 ? :black : :white
      Bishop.new(pos, board, color)
    end
  end
  def initialize(position, board, color)
    @symbol = (color == :black) ? "\u265D" : "\u2657"
    super
  end

  def move_dirs
    [[1,1],[1,-1],[-1,1],[-1,-1]]
  end
end
