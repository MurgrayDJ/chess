require_relative '../piece.rb'

class Pawn < Piece
  attr_accessor :has_moved
  attr_accessor :moves
  attr_accessor :en_passant_available
  attr_accessor :en_passant_round_start

  def initialize(color, start_pos)
    super(color, start_pos, :pawn)
    @has_moved = false
    @en_passant_available = false
    @en_passant_round_start = -1
    set_symbol(color)
    set_moves(color)
  end

  def delete_en_passant
    if @en_passant_available 
      @en_passant_available = false
      @moves.delete(:en_passant)
      @en_passant_round_start = nil
    end
  end

  def en_passant_update(side, round)
    @en_passant_round_start = round
    @en_passant_available = true
    if @color == :white
      if side == :right
        @moves[:en_passant] = [1,1]
      else
        @moves[:en_passant] = [1,-1]
      end
    else
      if side == :right
        @moves[:en_passant] = [-1,1]
      else
        @moves[:en_passant] = [-1,-1]
      end
    end
  end

  def set_symbol(color)
    if color == :white
      @symbol = "\u265F"
    else
      @symbol = "\u2659"
    end
  end

  def update_piece(next_pos)
    super
    @has_moved = true
    @moves.delete(:two_squares)
  end

  def set_moves(color)
    if color == :black
      @moves = {one_square: [[1,0]],
                two_squares: [[2,0]]}
    else
      @moves = {one_square: [[-1,0]],
                two_squares: [[-2,0]]}
    end
  end

  def get_moves
    super(@moves)
  end
end