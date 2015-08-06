require_relative 'board.rb'

class Game
  attr_accessor :board, :players

  def initialize(board = nil)
    if board.nil?
      @board = Board.new
      @board.setup_board
    else
      @board = board
    end
    @players =  [:white, :black]
  end

  def play
    system('clear')
    until over?
      board.render
      begin
        prompt
        try_move(get_input)
      rescue InvalidMoveError => a
        puts "#{a}"
        retry
      rescue WrongPlayerError => e
        puts "#{e}"
        retry
      rescue
        puts "Invalid Input"
        retry
      end
      switch_players
      system('clear')
    end
  end

  def try_move(input)
    move_piece = board[input.first]
    raise WrongPlayerError if move_piece.color != current_player
    moves = input.drop(1)
    move_piece.perform_moves(moves)
  end
  def prompt
    puts "#{current_player}'s turn"
    puts "Please select piece, then destination(s)"
    puts "eg 5,7; (3,5) (1,3) "
  end

  def get_input
    coords = gets.chomp.scan(/\d/).each_slice(2).to_a
    coords.map { |coord| coord.map(&:to_i) }
  end

  def current_player
    players.first
  end

  def switch_players
    players.reverse!
  end

  def over?
    board.pieces.all? { |piece| piece.color == :white} ||
      board.pieces.all? { |piece| piece.color == :black}
  end
end

class InvalidMoveError < StandardError
end
class WrongPlayerError < StandardError
end

a = Game.new
a.play
