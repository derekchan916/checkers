require_relative 'piece.rb'
require 'colorize'
require 'byebug'

class Board
  BOARD_SIZE = 8
  attr_accessor :grid, :graveyard

  def initialize
    make_grid
    @graveyard = []
    #p pieces
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []= (pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def render
    puts "  0 1 2 3 4 5 6 7"
    grid.each_with_index do |row, idx|
      print "#{idx} "
      row.each_with_index do |piece, idy|
        bg_color = ((idx + idy).even? ? :light_white : :white)
        output = piece.nil? ? "  " : "#{piece.render} "
        print output.colorize(:background => bg_color)
      end
      print "\n"
    end
    print "\n\n"
    p graveyard
  end

  def move_piece(pos, to_pos)
    #debugger
    piece = self[pos]
    self[to_pos] = piece
    self[pos] = nil
    piece.pos = to_pos
    #p pieces
    nil
  end

  def eat_piece(color, from_pos, to_pos)
    enemy_pos = avg(from_pos, to_pos)

    graveyard << self[enemy_pos]
    self[enemy_pos] = nil
  end

  def pieces
    @grid.flatten.compact
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
    end_row = (color == :red ? 7 : 0)

    pos[0] == end_row
  end

  private
  def make_grid
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }

    [:black, :red].each { |color| populate_grid(color) }
  end

  def populate_grid(color)
    start_row = (color == :red ? 0 : 5)

    idx = start_row
    until idx == (start_row + 3)
      @grid[idx].each_index do |idy|
        if idx.even?
          self[[idx, idy]] = Piece.new([idx, idy], color, self) if idy.even?
        else
          self[[idx, idy]] = Piece.new([idx, idy], color, self) if idy.odd?
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
