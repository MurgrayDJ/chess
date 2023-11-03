

class Piece
  attr_accessor :symbol
  attr_accessor :type
  attr_accessor :color
  attr_accessor :name
  attr_accessor :start_pos
  attr_accessor :current_pos

  def initialize(color, start_pos, type)
    @color = color
    @type = type
    @start_pos = start_pos
    @current_pos = start_pos
    set_symbol
  end

  def set_symbol
    if @type == :black
      @symbol = "\u265a"
    else
      @symbol = "\u2654"
    end
  end

  def update_piece(next_pos)
    @current_pos = next_pos
  end

  def generate_moves(moves)
    moves.map {|move| [current_pos[0] + move[0], current_pos[1] + move[1]]}
                        .select {|move| move[0].between?(1,8) && move[1].between?(1,8)}
  end

  def get_moves(moves)
    possible_moves = ''
    if moves.is_a?(Array)
      possible_moves = []
      possible_moves = generate_moves(moves)
    else
      possible_moves = {}
      moves.each do |direction, move_list|
        possible_moves[direction] = generate_moves(move_list)
      end
    end
    possible_moves
  end
end