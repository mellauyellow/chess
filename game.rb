require_relative 'board'
require_relative 'piece'
require_relative 'player'
require_relative 'display'

class ChessGame

  def initialize(name1, name2)
    @player1 = HumanPlayer.new(name1, :white)
    @player2 = HumanPlayer.new(name2, :red)
    @board = Board.new_game
    @display = Display.new(@board)
    @current_player = @player1
  end

  def show
    @display.show
  end

  def play
    until @board.over?
      play_turn
      switch_player
    end

    puts "Game over!"
  end

  def play_turn
    @current_player.start_prompt
    start_pos = show
    @current_player.end_prompt
    end_pos = show

    @board.move(start_pos, end_pos, @current_player.color)
  rescue MoveError => e
    puts e.message
    sleep(1)
    retry
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end
end

if __FILE__ == $0
  game = ChessGame.new('p1','p2')
  game.play
end
