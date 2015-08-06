require_relative 'board.rb'
require 'byebug'

class Game
  attr_reader :board, :player1, :player2
  attr_accessor :current_player

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(:red)
    @player2 = HumanPlayer.new(:black)
    @current_player = @player1
  end

  def play
    until over?
      board.render
      puts "Current player is #{current_player.color}"
      begin
        piece_pos = current_player.get_start_pos_input
        moves_pos = current_player.get_move_input
        board.process(piece_pos, moves_pos)
      rescue InvalidMoveError => e
        puts e.message
        puts "\n"
        retry
      end
      switch_players
    end
    puts "Game is over!"
  end

  def over?
    board.pieces.none? { |piece| piece.color == :black || piece.color == :red }
  end

  def switch_players
    @current_player = (current_player == player1 ? player2 : player1)
  end
end

class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_start_pos_input
    puts "Which piece would you like to move?"
    gets.chomp.split(",").map(&:to_i)
  end

  def get_move_input
    puts "Where would you like to move? ex. x,y"
    input = []
    user_input = gets.chomp.split(",").map(&:to_i)

    loop do
      break if user_input.empty?
      input << user_input
      puts "After that? ex. x,y (Press enter to exit)"
      user_input = gets.chomp.split(",").map(&:to_i)
    end

    input
  end
end

game = Game.new
game.play
