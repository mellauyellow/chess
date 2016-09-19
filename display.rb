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
          print el.symbol.colorize(:background => :blue) + " "
        else
          print el.symbol + " "
        end
      end
      puts
    end
  end
end

if __FILE__ == $0
  board = Board.new
  board[[0,0]] = Piece.new([0,0])
  display = Display.new(board)
  display.show
end
