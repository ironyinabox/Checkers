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
        self.pos = end_pos
        return true
      else
        false
      end
      maybe_promote
    end

    def perform_jump(end_pos)
      if valid_jump?(end_pos)
        board[end_pos] = board[pos]
        board[jumped_pos(end_pos)] = nil
        board[pos] = nil
        return true
      else
        false
      end
      maybe_promote
    end

    def valid_slide?(end_pos)
      board.empty?(end_pos) &&
      moves.include?(end_pos)
    end

    def valid_jump?(end_pos)
      board.empty?(end_pos) &&
      jumps.include?(end_pos) &&
      enemy_there?(end_pos)
    end

    def move_diffs
      return DELTAS.flatten(1) if king?
      return DELTAS[0] if color == :black
      return DELTAS[1] if color == :white
    end

    def maybe_jumps
      move_diffs.map do |d_pos|
        d_row, d_col = d_pos
        o_row, o_col = pos
        jump_row = (d_row*2) + o_row
        jump_col = (d_col*2) + o_col
        [jump_row, jump_col]
      end
    end

    def jumped_pos(end_pos)
      e_row, e_col = end_pos
      s_row, s_col = pos
      jumped_row = (s_row + e_row)/2
      jumped_col = (e_col + s_col)/2
      [jumped_row, jumped_col]
    end

    def enemy_there?(end_pos)
      return false if board.empty?(jumped_pos(end_pos))
      return true if board[jumped_pos(end_pos)].color != color
      return false
    end

    def maybe_moves
      move_diffs.map do |d_pos|
        d_row, d_col = d_pos
        o_row, o_col = pos
        move_row = d_row + o_row
        move_col = d_col + o_col
        [move_row, move_col]
      end
    end

    def in_bounds_set(set)
      set.select { |move| move.all? { |num| num.between?(0,7) } }
    end

    def jumps
      in_bounds_set(maybe_jumps)
    end

    def moves
      in_bounds_set(maybe_moves)
    end

    def to_s
      if color == :black
        "B"
      else
        "W"
      end
    end

    def maybe_promote
      if self.color == :black && self.pos[0] == 7
        self.king = true
      elsif self.color == :white && self.pos[0] == 0
        self.king = true
      end
    end

    def perform_moves!(move_sequence)
      if move_sequence.size == 1 && perform_slide(move_sequence.first)
        return move_sequence.first
      end
      move_sequence.each do |move|
        raise InvalidMoveError if !perform_jump(move)
      end
    end

    def valid_move_seq?
    end
end
