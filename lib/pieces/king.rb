require_relative '../piece.rb'

class King < Piece
  attr_accessor :has_moved
  MOVES = [[1,-1], [1,0], [1,1], [0,-1], 
  [0,1], [-1,-1], [-1,0], [-1,1]].freeze

  def initialize(color, start_pos)
    super(color, start_pos, :king)
  end

  def set_symbol
    super
  end

  def update_piece(next_pos)
    super
    @has_moved = true
  end

  def get_moves
    super(MOVES)
  end
end