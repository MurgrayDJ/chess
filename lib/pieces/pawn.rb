require_relative '../piece.rb'

class Pawn < Piece
  attr_accessor :has_moved
  attr_accessor :moves

  def initialize(color, start_pos)
    super(color, start_pos, :pawn)
    @has_moved = false
    set_color(color)
  end

  def set_symbol
    super
  end

  def set_color(color)
    if color == :black
      @moves = {one_square: [[1,0]],
                two_squares: [[2,0]]}
    else
      @moves = {one_square: [[-1,0]],
                two_squares: [[-2,0]]}
    end
  end

  def get_moves
    if @has_moved then @moves.delete(:two_squares) end
    super(@moves)
  end
end