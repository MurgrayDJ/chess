require_relative '../piece.rb'

class Rook < Piece
  MOVES = {
    north: [[1,0], [2,0], [3,0], [4,0], [5,0], [6,0], [7,0]],
    east: [[0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7]],
    south: [[-1,0], [-2,0], [-3,0], [-4,0], [-5,0], [-6,0], [-7,0]],
    west: [[0,-1], [0,-2], [0,-3], [0,-4], [0,-5], [0,-6], [0,-7]]
  }.freeze

  def initialize(color, start_pos)
    super(color, start_pos, :rook)
  end

  def set_symbol(color)
    if color == :white
      @symbol = "\u265C"
    else
      @symbol = "\u2656"
    end
  end

  def update_piece(next_pos)
    super
  end

  def get_moves
    super(MOVES)
  end
end