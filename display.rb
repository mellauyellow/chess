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
  piece = King.new([0,1], board, :red)
  new_board = Board.new
  block = piece.dup(new_board)

  block.position[0] = 'changed'

  p piece.position
  p block.position
  # display = Display.new(board)
  # display.show
end
