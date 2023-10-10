
class Board
  attr_accessor :board
  ROWS = 8
  COLUMNS = 8

  def initialize
    @board = Array.new(ROWS){Array.new(COLUMNS){"\u2237"}}
  end
end

# board_class = Board.new()
# p board_class.board
