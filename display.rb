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

  def show(valid_moves = [[]])
    move = nil
    while move.nil?
      system("clear")
      render(@cursor.cursor_pos, valid_moves)
      move = @cursor.get_input
    end
    move
  end

  def render(cursor_pos, valid_moves)
    puts "  #{('a'..'h').to_a.join(' ')}"
    @board.grid.each_with_index do |row, idx|
      print "#{8 - idx} "
      row.each_with_index do |el, idx2|
        render_square(idx, idx2, el, valid_moves)
      end
      puts
    end
  end

  def render_square(row, col, piece, valid_moves)
    text = piece.to_s + " "
    if [row, col] == @cursor.cursor_pos
      print text.colorize(:background => :blue)
    elsif valid_moves.include?([row, col])
      print text.colorize(:background => :green)
    elsif (row.even? && col.even?) || (row.odd? && col.odd?)
      print text.colorize(:background => :light_black)
    else
      print text
    end
  end
end
