require_relative '../piece'
require_relative './sliding'

class Rook < Piece
  include SlidingPiece
  def self.setup(board)
    [[0,0],[0,7],[7,0],[7,7]].each do |pos|
      color = pos[0] == 0 ? :black : :white
      Rook.new(pos, board, color)
    end
  end
  def initialize(position, board, color)
    @symbol = (color == :black) ? "\u265C".encode('utf-8') : "\u2656".encode('utf-8')
    super
  end

  def move_dirs
    [[1,0],[0,1],[-1,0],[0,-1]]
  end
end
