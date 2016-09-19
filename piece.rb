class Piece
  attr_reader :symbol
  def initialize(position)
    @position = position
    @symbol = '*'
  end
end

class NullPiece
  attr_reader :symbol
  def initialize
    @symbol = ' '
    # @position = position
  end
end
