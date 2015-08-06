require_relative 'board.rb'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    p @board.render
    p @board[[2,0]].perform_slide([3,1])
    p @board.render
    p @board[[5,1]].perform_slide([4, 2])
    p @board.render
    p @board[[5,3]].perform_slide([4, 4])
    p @board.render
    p @board[[3,1]].perform_jump([5, 3])
    p @board.render
    # p @board[[5,3]].perform_slide([6,3])
    # p @board.render

    # p @board[[4,4]].perform_jump([0, 1])
    # p @board.render
    # p @board[[0,1]].perform_slide([1,2])
    # p @board.render
    # p @board[[5,3]].perform_jump([4, 2])
    # p @board.render
  end
end

game = Game.new
