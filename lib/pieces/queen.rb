require_relative '../piece.rb'

class Queen < Piece
  MOVES = [[1,-1], [1,0], [1,1], [0,-1], 
  [0,1], [-1,-1], [-1,0], [-1,1]].freeze

  def initialize(color, start_pos)
    super(color, start_pos, :queen)
  end

  def set_symbol
    super
  end

  def get_moves
    super(MOVES)
  end
end