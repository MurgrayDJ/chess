require_relative '../piece.rb'

class Pawn < Piece
  MOVES = [[1,0]].freeze

  def initialize(color, start_pos)
    super(color, start_pos, :pawn)
  end

  def set_symbol
    super
  end

  def get_moves
    super(MOVES)
  end
end