require_relative '../piece.rb'

class Bishop < Piece
  MOVES = {
    northeast: [[1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7]],
    southeast: [[-1,1], [-2,2], [-3,3], [-4,4], [-5,5], [-6,6], [-7,7]],
    southwest: [[-1,-1], [-2,-2], [-3,-3], [-4,-4], [-5,-5], [-6,-6], [-7,-7]],
    northwest: [[1,-1], [2,-2], [3,-3], [4,-4], [5,-5], [6,-6], [7,-7]]
  }.freeze

  def initialize(color, start_pos)
    super(color, start_pos, :bishop)
  end

  def set_symbol
    super
  end

  def get_moves
    super(MOVES)
  end
end