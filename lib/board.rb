require_relative '../lib/pieces/king.rb'

class Board
  attr_accessor :board
  ROWS = 10
  COLUMNS = 10
  DOTS = "\u2237"

  def initialize
    # @board = board_setup
    @board = [
      [" ", "a", "b", "c", "d", "e", "f", "g", "h", " "],
      [8, DOTS, " ", DOTS, " ", DOTS, " ", DOTS, " ", 8],
      [7, " ", DOTS, " ", DOTS, " ", DOTS, " ", DOTS, 7],
      [6, DOTS, " ", DOTS, " ", DOTS, " ", DOTS, " ", 6],
      [5, " ", DOTS, " ", DOTS, " ", DOTS, " ", DOTS, 5],
      [4, DOTS, " ", DOTS, " ", DOTS, " ", DOTS, " ", 4],
      [3, " ", DOTS, " ", DOTS, " ", DOTS, " ", DOTS, 3],
      [2, DOTS, " ", DOTS, " ", DOTS, " ", DOTS, " ", 2],
      [1, " ", DOTS, " ", DOTS, " ", DOTS, " ", DOTS, 1],
      [" ", "a", "b", "c", "d", "e", "f", "g", "h", " "]
    ]
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
        if val.instance_of?(Pieces) then val = val.symbol end
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

  def move_piece(curr_pos, next_pos)
    @board[next_pos[0]][next_pos[1]] = @board[curr_pos[0]][curr_pos[1]]
    update_old_spot(curr_pos[0], curr_pos[1])
  end
  
  def update_old_spot(row, col)
    sum = row + col
    if sum.odd?
      @board[row][col] = " "
    elsif sum.even?
      @board[row][col] = DOTS
    end
  end

  def check_surroundings(piece, move_list)
    move_list.delete_if do |spot|
      spot_val = @board[spot[0]][spot[1]]
      if spot_val.instance_of?(String)
        next
      elsif spot_val.type == piece.type
        true
      end
    end
    move_list
  end
  ### OLD BOARD SETUP METHODS
  # def board_setup 
  #   new_board = Array.new(ROWS){Array.new(COLUMNS){"\u2237"}}
  #   add_files(new_board)
  #   add_ranks(new_board)
  #   add_spaces(new_board)
  #   new_board
  # end

  # def add_files(new_board)
  #   files = [" ", "a", "b", "c", "d", "e", "f", "g", "h", " "]
  #   new_board[0] = files.map(&:clone)
  #   new_board[9] = files.map(&:clone)
  # end

  # def add_ranks(new_board)
  #   ranks = [" ", 8, 7, 6, 5, 4, 3, 2, 1, " "]
  #   ranks.each_with_index do |rank, idx|
  #     new_board[idx][0] = rank
  #     new_board[idx][9] = rank
  #   end
  # end

  # def add_spaces(new_board)
  #   (8).downto(1) do |row|
  #     (8).downto(1) do |col|
  #       if col.odd? && row.even?
  #         new_board[row][col] = " "
  #       elsif col.even? && row.odd?
  #         new_board[row][col] = " "
  #       end
  #     end
  #   end
  # end
end

# board_class = Board.new()
# p board_class.board
