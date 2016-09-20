require_relative '../piece'
require_relative './stepping'

class King < Piece
  include SteppingPiece
  
  def self.setup(board)
    [[0,4],[7,4]].each do |pos|
      color = pos[0] == 0 ? :black : :white
      King.new(pos, board, color)
    end
  end

  def initialize(position, board, color)
    @symbol = (color == :black) ? "\u265A".encode('utf-8') : "\u2654".encode('utf-8')
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
