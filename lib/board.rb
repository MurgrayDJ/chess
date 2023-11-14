require_relative 'piece.rb'

class Board
  attr_accessor :board
  ROWS = 10
  COLUMNS = 10
  DOTS = "\u2237"
  RANKS = [nil, 8, 7, 6, 5, 4, 3, 2, 1].freeze

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
    top_line = " ___    ________________________________   ___ \n"
    bottom_line = " ̅ ̅ ̅     ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅    ̅ ̅ ̅  \n"
    print top_line 
    print_rows(top_line, bottom_line)
    print bottom_line
  end

  def print_rows(top_line, bottom_line)
    @board.each_with_index do |row, row_num|
      if row_num == 9 then print top_line end
      if row_num == 1 then print top_line end
      row.each_with_index do |val, col_num|
        if val.respond_to?(:symbol) then val = val.symbol end
        if col_num != 1 && col_num != 9
          print "| #{val} "
        elsif col_num == 1
          print "|  | #{val} "
        elsif col_num == 9
          print "|  | #{val} "
        end
      end
      print "| \n"
      if row_num == 0 then print bottom_line end
      if row_num == 8 then print bottom_line end
    end
  end

  def square_to_xy(file, rank)
    x = RANKS[rank.to_i]
    y = file.upcase.ord - 64
    [x,y]
  end

  def xy_to_square(coord)
    rank = RANKS.find_index(coord[0])
    file = (coord[1] + 64).chr.downcase
    "#{file}#{rank}"
  end

  def move_piece(square1, square2)
    curr_pos = square_to_xy(square1[0], square1[1].to_i)
    next_pos = square_to_xy(square2[0], square2[1].to_i)
    curr_piece = @board[curr_pos[0]][curr_pos[1]]
    @board[next_pos[0]][next_pos[1]] = curr_piece
    curr_piece.update_piece(next_pos)
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

  def delete_move(piece, move_list)
    move_list.delete_if do |spot|
      spot_val = @board[spot[0]][spot[1]]
      if spot_val.instance_of?(String)
        next
      elsif spot_val.color == piece.color
        true
      end
    end
    move_list
  end

  def delete_moves(piece, moves)
    moves.values.each do |move_list|
      move_list.each_with_index do |move, idx|
        spot_val = @board[move[0]][move[1]]
        if spot_val.instance_of?(String)
          next
        elsif spot_val.color == piece.color
          indices_to_remove = (idx..move_list.length-1)
          move_list.delete_if.with_index{|_, i| indices_to_remove.include?(i)}
        elsif spot_val.color != piece.color
          indices_to_remove = (idx+1..move_list.length-1)
          move_list.delete_if.with_index{|_, i| indices_to_remove.include?(i)}
        end
      end
    end
    moves
  end

  def check_surroundings(piece, moves)
    if moves.is_a?(Array)
      delete_move(piece, moves)
    else
      delete_moves(piece, moves)
    end
  end
end

# board_class = Board.new()
# p board_class.board
