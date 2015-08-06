require "byebug"

class Piece
  attr_reader :color, :board
  attr_accessor :pos, :king

  def initialize(pos, color, board, king = false)
    @pos, @color, @board, @king = pos, color, board, king

    board.add_piece(self, pos)
  end

  def perform_slide(to_pos)
    return false unless valid_move?(to_pos) &&
      valid_slide?(to_pos)

    board.move_piece(pos, to_pos)
    maybe_promote
    return true
  end

  def perform_jump(to_pos)
    return false unless valid_move?(to_pos) &&
      board.enemy_present?(color, pos, to_pos) &&
        valid_jump?(to_pos)

    board.eat_piece(color, pos, to_pos)
    board.move_piece(pos, to_pos)
    maybe_promote
    return true
  end

  def perform_moves!(move_sequence)
    if move_sequence.count == 1
      raise InvalidMoveError.new ("You can't do that!") unless
        perform_slide(move_sequence.first) ||
          perform_jump(move_sequence.first)

    else
      raise InvalidMoveError.new ("Invalid move sequence!") unless
        valid_move_seq?(move_sequence)

      until move_sequence.empty?
        perform_jump(move_sequence.shift)
      end
    end
  end

  def valid_move_seq?(move_sequence)
    new_board = board.dup
    from_pos = pos

    move_sequence.each do |to_pos|
      return false if !new_board[from_pos].perform_jump(to_pos)
      from_pos = to_pos
    end

    return true
  end

  def valid_move?(to_pos) #valid_move
    board.valid_move?(to_pos) &&
      board.empty?(to_pos) &&
        valid_direction?(to_pos)
  end

  def maybe_promote
    @king = true if board.end_of_board?(color, pos)
  end

  def move_dir #dir
    color == :red ? 1 : -1
  end

  def render
    if king
      color == :red ? "\u26AA".encode('utf-8') : "\u26AB".encode('utf-8')
    else
      color == :red ? "\u26AA".encode('utf-8') : "\u26AB".encode('utf-8')
    end
  end

  def inspect
    #pos.join(",") + " " + color.to_s + " " + king.to_s
    render
  end

  private
  def valid_direction?(to_pos)
    return true if king
    direction = (to_pos[0] - pos[0])

    (move_dir * direction.abs) == direction
  end

  def valid_slide?(to_pos)
    diff = to_pos[1] - pos[1]

    diff.abs == 1
  end

  def valid_jump?(to_pos)
    diff = to_pos[1] - pos[1]

    diff.abs == 2
  end
end

class InvalidMoveError < StandardError
end
