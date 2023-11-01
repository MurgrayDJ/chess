require_relative '../piece.rb'

class Queen < Piece
  attr_reader :moves

  def initialize(color, start_pos)
    super(color, start_pos, :queen)
    @moves = []
    generate_moves
  end

  def set_symbol
    super
  end

  def generate_moves
    (1..7).each do |num|
      current_nums = [0, num, -num]
      temp_array = current_nums.product(current_nums)
      temp_array.delete([0,0])
      @moves.push(*temp_array)
    end
  end

  def get_moves
    super(@moves)
  end
end