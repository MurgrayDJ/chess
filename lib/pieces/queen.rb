require_relative '../piece.rb'

class Queen < Piece
  attr_reader :moves
  MOVES = {
    north: [[1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0]],
    northeast: [[1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7]],
    east: [[0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7]],
    southeast: [[-1,1], [-2,2], [-3,3], [-4,4], [-5,5], [-6,6], [-7,7]],
    south: [[-1,0], [-2,0], [-3,0], [-4,0], [-5,0], [-6,0], [-7,0]],
    southwest: [[-1,-1], [-2,-2], [-3,-3], [-4,-4], [-5,-5], [-6,-6], [-7,-7]],
    west: [[0,-1], [0,-2], [0,-3], [0,-4], [0,-5], [0,-6], [0,-7]],
    northwest: [[1,-1], [2,-2], [3,-3], [4,-4], [5,-5], [6,-6], [7,-7]]
  }.freeze

  def initialize(color, start_pos)
    super(color, start_pos, :queen)
    set_symbol(color)
  end

  def set_symbol(color)
    if color == :white
      @symbol = "\u265B"
    else
      @symbol = "\u2655"
    end
  end

  def update_piece(next_pos)
    super
  end

  def get_moves
    super(MOVES)
  end
end