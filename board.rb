require_relative 'piece.rb'
require 'colorize'
require 'byebug'

class Board
  BOARD_SIZE = 8
  attr_accessor :grid, :graveyard

  def initialize(fill = true)
    make_grid(fill)
    @graveyard = []
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []= (pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def add_piece(piece, pos)
    self[pos] = piece
  end

  def render
    puts "  0 1 2 3 4 5 6 7"
    grid.each_with_index do |row, idx|
      print "#{idx} "
      row.each_with_index do |piece, idy|
        bg_color = ((idx + idy).even? ? :red : :white)
        output = piece.nil? ? "  " : "#{piece.render} "
        print output.colorize(:background => bg_color)
      end
      print "\n"
    end
    print "\n\n"
    puts "Red has eaten: #{graveyard.select{|piece| piece.color == :black}}"
    puts "Black has eaten: #{graveyard.select{|piece| piece.color == :red}}"
  end

  def move_piece(pos, to_pos)
    piece = self[pos]
    self[to_pos] = piece
    self[pos] = nil
    piece.pos = to_pos
  end

  def eat_piece(color, from_pos, to_pos)
    enemy_pos = avg(from_pos, to_pos)

    graveyard << self[enemy_pos]
    self[enemy_pos] = nil
  end

  def pieces
    @grid.flatten.compact
  end

  def process(piece_pos, moves)
    self[piece_pos].perform_moves!(moves)
  end

  def dup
    new_board = Board.new(false)

    pieces.each do |piece|
      piece.class.new(piece.pos, piece.color, new_board, piece.king)
    end

    new_board
  end

  def empty?(pos)
    self[pos].nil?
  end

  def valid_move?(to_pos)
    to_pos.all? { |coord| coord.between?(0, BOARD_SIZE) }
  end

  def enemy_present?(color, from_pos, to_pos)
    enemy_pos = avg(from_pos, to_pos)

    !self[enemy_pos].nil? && self[enemy_pos].color != color
  end

  def end_of_board?(color, pos)
    end_row = (color == :red ? BOARD_SIZE - 1 : 0)

    pos[0] == end_row
  end

  private
  def make_grid(fill)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }

    [:black, :red].each { |color| populate_grid(color) } if fill
  end

  def populate_grid(color)
    start_row = (color == :red ? 0 : 5)

    idx = start_row
    until idx == (start_row + 3)
      @grid[idx].each_index do |idy|
        if idx.even?
          Piece.new([idx, idy], color, self) if idy.even?
        else
          Piece.new([idx, idy], color, self) if idy.odd?
        end
      end

      idx += 1
    end
    nil
  end

  def avg(from_pos, to_pos)
    x, y = from_pos
    dx, dy = to_pos
    middle_pos = [(x + dx) / 2, (y + dy) / 2]
  end
end
