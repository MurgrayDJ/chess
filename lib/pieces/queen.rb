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
    # @moves = []
    # generate_moves
  end

  def set_symbol
    super
  end

  # def generate_moves
  #   (1..7).each do |num|
  #     current_nums = [0, num, -num]
  #     temp_array = current_nums.product(current_nums)
  #     temp_array.delete([0,0])
  #     @moves.push(*temp_array)
  #   end
  # end

  def get_moves
    super(MOVES)
  end
end