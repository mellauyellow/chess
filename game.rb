require_relative 'board'
require 'require_all'
require_all 'pieces'
require_relative 'player'
require_relative 'display'

class ChessGame
  def self.new_board
    board = Board.new
    Pawn.setup(board)
    Knight.setup(board)
    Rook.setup(board)
    Queen.setup(board)
    Bishop.setup(board)
    King.setup(board)
    board
  end

  def initialize(name1, name2)
    @player1 = HumanPlayer.new(name1, :white)
    @player2 = HumanPlayer.new(name2, :black)
    @board = ChessGame.new_board
    @display = Display.new(@board)
    @current_player = @player1
  end

  def show(valid_moves = [[]])
    @display.show(valid_moves)
  end

  def play
    until @board.over?
      play_turn
      switch_player
      in_check?
    end

    puts "Game over!"
  end

  def play_turn
    @current_player.start_prompt
    start_pos = show
    valid_moves = @board[start_pos].valid_moves
    @current_player.end_prompt
    end_pos = show(valid_moves)

    @board.move(start_pos, end_pos, @current_player.color)
  rescue MoveError => e
    puts e.message
    sleep(1)
    retry
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  private

  def in_check?
    puts "In check!" if @board.in_check?(@current_player.color)
    sleep(0.5)
  end
end

if __FILE__ == $0
  game = ChessGame.new('p1','p2')
  game.play
end
