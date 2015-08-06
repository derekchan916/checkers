require "byebug"

class Piece
  attr_reader :color, :board
  attr_accessor :pos, :king

  def initialize(pos, color, board, king = false)
    @pos, @color, @board, @king = pos, color, board, king
  end

  def perform_slide(to_pos)
    valid_move(to_pos)
    raise "You can't slide like that" unless valid_slide?(to_pos)

    board.move_piece(pos, to_pos)
    maybe_promote
  end

  def perform_jump(to_pos)
    valid_move(to_pos)
    raise "No enemy there" unless board.enemy_present?(color, pos, to_pos)
    raise "You can't jump like that" unless valid_jump?(to_pos)

    board.eat_piece(color, pos, to_pos)
    board.move_piece(pos, to_pos)
    maybe_promote
  end

  def perform_moves!(move_sequence)
    if move_sequence.count == 1
      begin
        perform_slide(move_sequence.first)
      ensure
        perfor_jump(move_sequence.first)
      end
    end
  end

  def valid_move(to_pos) #valid_move
    raise "You went off the board!" unless board.valid_move?(to_pos)
    raise "There is something in the way!" unless board.empty?(to_pos)
    raise "You can't move in that direction" unless valid_direction?(to_pos)
  end

  def maybe_promote
    @king = true if board.end_of_board?(color, pos)
  end

  def move_dir #dir
    color == :red ? 1 : -1
  end

  def render
    if king
      color == :red ? :R : :B
    else
      color == :red ? :r : :b
    end
  end

  def inspect
    pos.join(",") + " " + color.to_s + " " + king.to_s
    #render
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
