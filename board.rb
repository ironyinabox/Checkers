require_relative 'piece.rb'

class Board
  attr_accessor :grid

  SIZE = 8

  def initialize
    @grid = Array.new(SIZE) {Array.new(SIZE)}
    setup_board
  end

  def setup_board
    (0..2).each { |row| set_col(row, :black) }
    (5..7).each { |row| set_col(row, :white) }
  end

  def set_col(row_idx, color)
    rows[row_idx].each_with_index do |tile, col|
      add_piece([row_idx, col], color) if (col%2 == row_idx%2)
    end
  end

  def empty?(pos)
    self[pos].nil?
  end

  def render
    puts "   0 1 2 3 4 5 6 7"
    puts "   ---------------"
    rows.each_with_index do |row, idx|
      print "#{idx}: "
      row.each do |tile|
        print (tile.nil? ? "_ " : tile.to_s.concat(" "))
      end
      puts
    end
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    grid[row][col] = piece
  end

  def rows
    grid
  end

  def pieces
    grid.flatten.compact
  end

  def add_piece(start_pos, color)
    self[start_pos] = Piece.new(start_pos, self, color )
  end

  def dup
    dup_board = Board.new
    pieces.each do |piece|
      dup_board[piece.pos] = piece.dup(dup_board)
    end
    dup_board
  end
end

a = Board.new
a.add_piece([4,0], :white)
a.add_piece([1,3], :black)
a.render
a[ [4,0] ].perform_moves([ [3,1] ])
a.render
p a[[3,1]].king?
# a.setup_board
# a.render
# puts
# puts
# a[[5,1]].perform_slide([4, 2])
# a.render
# puts
# puts
# a[[2,4]].perform_slide([3, 3])
# a.render
# puts
# puts
# a[[4,2]].perform_jump([2,4])
# a.render
# puts
# puts
# a.add_piece([1,0], :white)
# a[[1,0]].perform_slide([0, 1])
# a.render
# p a[[0,1]].king?
