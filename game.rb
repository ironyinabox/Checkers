class Game
  attr_accessor :board, :players

  def initialize(board = nil)
    @board = (board.nil? ? Board.new : board)
    @players =  [:white, :black]
  end

  def play
    until over?
      board.render
      prompt
      get_input
      make_moves
      switch_players
    end
  end

  def prompt
    puts "#{players}"
    puts "Please select piece, then destination(s)"
    puts "eg "
  end

  def get_input

  end

  def current_player
    players.first
  end

  def switch_players
    players.reverse!
  end

end
