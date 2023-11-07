require_relative '../piece.rb'

class Pawn < Piece
  attr_accessor :has_moved
  attr_accessor :moves

  def initialize(color, start_pos)
    super(color, start_pos, :pawn)
    @has_moved = false
    set_symbol(color)
    set_moves(color)
  end

  def set_symbol(color)
    if color == :white
      @symbol = "\u2659"
    else
      @symbol = "\u265F"
    end
  end

  def update_piece(next_pos)
    super
    @has_moved = true
    @moves.delete(:two_squares)
  end

  def set_moves(color)
    if color == :black
      @moves = {one_square: [[1,0]],
                two_squares: [[2,0]]}
    else
      @moves = {one_square: [[-1,0]],
                two_squares: [[-2,0]]}
    end
  end

  def get_moves
    super(@moves)
  end
end