require 'colorize'
require_relative 'cursor'
require_relative 'board'
require_relative 'piece'

class Display
  attr_reader :cursor
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], @board)
  end

  def show
    while true
      system("clear")
      render(@cursor.cursor_pos)
      @cursor.get_input
    end
  end

  def render(cursor_pos)
    puts "  #{(0..7).to_a.join(' ')}"
    @board.grid.each_with_index do |row, idx|
      print "#{idx} "
      row.each_with_index do |el, idx2|
        if [idx, idx2] == cursor_pos
          print el.to_s.colorize(:background => :blue) + " "
        else
          print el.to_s + " "
        end
      end
      puts
    end
  end
end

if __FILE__ == $0
  board = Board.new
  piece = Pawn.new([4,4], board, :red)
  block = Rook.new([5,5], board, :white)
  board[[4,4]] = piece
  board[[5,5]] = block
  p piece.valid_moves
  # display = Display.new(board)
  # display.show
end
