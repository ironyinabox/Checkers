class Piece
    attr_accessor :pos, :board, :color, :king

    DELTAS = [
    [ [ 1,  1], [ 1, -1] ],  #black moves
    [ [-1,  1], [-1, -1] ]   #white moves
    ]

    def initialize(pos, board=nil, color = nil)
      @pos = pos
      @board = board
      @color = color
      @king = false
    end

    def king?
      @king
    end

    def perform_slide(end_pos)
      if valid_slide?(end_pos)
        board[end_pos] = board[pos]
        board[pos] = nil
        return true
      else
        false
      end
    end

    def perform_jump(end_pos)
    end

    def valid_slide?(end_pos)
      board.empty?(end_pos) &&
      moves.include?(end_pos)
    end

    def valid_jump?(end_pos)
    end

    def move_diffs
      return DELTAS.flatten(1) if king?
      return DELTAS[0] if color == :black
      return DELTAS[1] if color == :white
    end

    def maybe_moves
      move_diffs.map do |d_pos|
        d_row, d_col = d_pos
        o_row, o_col = pos
        [d_row + o_row, d_col + o_col]
      end
    end

    def moves
      maybe_moves.select { |move| move.all? { |num| num.between?(0,7) } }
    end

    def to_s
      if color == :black
        "B"
      else
        "W"
      end
    end
end
