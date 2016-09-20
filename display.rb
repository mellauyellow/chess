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
    move = nil
    while move.nil?
      system("clear")
      render(@cursor.cursor_pos)
      move = @cursor.get_input
    end
    move
  end

  def render(cursor_pos)
    puts "  #{('a'..'h').to_a.join(' ')}"
    @board.grid.each_with_index do |row, idx|
      print "#{8 - idx} "
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
