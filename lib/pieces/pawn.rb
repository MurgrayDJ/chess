require_relative '../piece.rb'

class Pawn < Piece
  attr_accessor :has_moved
  MOVES = [[1,0]]

  def initialize(color, start_pos)
    super(color, start_pos, :pawn)
    @has_moved = false
  end

  def set_symbol
    super
  end

  def get_moves
    super(MOVES)
  end
end