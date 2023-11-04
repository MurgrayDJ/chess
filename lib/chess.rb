require_relative './board.rb'

class Chess
  attr_accessor :board
  
  def initalize
    @board = Board.new()
  end

end