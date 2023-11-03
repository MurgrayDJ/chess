require_relative '../piece.rb'

class Knight < Piece
  MOVES = [[-1,-2], [-1,2], [1,-2], [1,2], 
  [-2,-1], [-2,1], [2,-1], [2,1]].freeze

  def initialize(color, start_pos)
    super(color, start_pos, :knight)
  end

  def set_symbol
    super
  end

  def update_piece(next_pos)
    super
  end

  def get_moves
    super(MOVES)
  end
end