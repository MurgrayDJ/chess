require_relative "pieces.rb"

class King < Pieces
  MOVES = [[1,-1], [1,0], [1,1],[0,-1], 
          [0,1], [-1,-1], [-1,0], [-1,1]].freeze
  
  def initialize(type, start_pos)
    super
  end

  def set_symbol
    super
  end

  def get_moves
    super(MOVES)
  end
end