
class Board
  attr_accessor :board
  ROWS = 10
  COLUMNS = 10

  def initialize
    @board = board_setup
  end

  def board_setup 
    new_board = Array.new(ROWS){Array.new(COLUMNS){"\u2237"}}
    add_files(new_board)
    add_ranks(new_board)
    add_spaces(new_board)
    new_board
  end

  def add_files(new_board)
    files = [" ", "a", "b", "c", "d", "e", "f", "g", "h", " "]
    new_board[0] = files.map(&:clone)
    new_board[9] = files.map(&:clone)
  end

  def add_ranks(new_board)
    ranks = [" ", 8, 7, 6, 5, 4, 3, 2, 1, " "]
    ranks.each_with_index do |rank, idx|
      new_board[idx][0] = rank
      new_board[idx][9] = rank
    end
  end

  def add_spaces(new_board)
    (8).downto(1) do |row|
      (8).downto(1) do |col|
        if col.odd? && row.even?
          new_board[row][col] = " "
        elsif col.even? && row.odd?
          new_board[row][col] = " "
        end
      end
    end
  end

  def print_board
    # top_line = " " + ("_" * 39) + "\n"
    # bottom_line = (" \u0305" * 39) + "\n"
    top_line = " ___    ________________________________    ___ \n"
    bottom_line = " ̅ ̅ ̅     ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅     ̅ ̅ ̅  \n"
    print top_line 
    print_rows(top_line, bottom_line)
    print bottom_line
  end

  def print_rows(top_line, bottom_line)
    @board.each_with_index do |row, row_num|
      if row_num == 9 then print top_line end
      if row_num == 1 then print top_line end
      row.each_with_index do |val, col_num|
        if col_num != 1 && col_num != 9
          print "| #{val} "
        elsif col_num == 1
          print "|  | #{val}  "
        elsif col_num == 9
          print "|  | #{val} "
        end
      end
      print "| \n"
      if row_num == 0 then print bottom_line end
      if row_num == 8 then print bottom_line end
    end
  end
end

# board_class = Board.new()
# p board_class.board
