
class Board
  attr_accessor :board
  ROWS = 10
  COLUMNS = 10

  def initialize
    @board = board_setup
  end

  def board_setup 
    new_board = Array.new(ROWS){Array.new(COLUMNS){"\u2237"}}
    files = [" ", "a", "b", "c", "d", "e", "f", "g", "h", " "]
    ranks = [" ", 8, 7, 6, 5, 4, 3, 2, 1, " "]
    new_board[0] = files.map(&:clone)
    new_board[9] = files.map(&:clone)
    new_board
  end

  def print_board
    @board.each do |row| 
      p row
    end
  end
end

# board_class = Board.new()
# p board_class.board
