

class Piece
  attr_accessor :symbol
  attr_accessor :type
  attr_accessor :color
  attr_accessor :name
  attr_accessor :start_pos
  attr_accessor :current_pos
  MOVES = {
    king: [[1,-1], [1,0], [1,1],[0,-1], 
          [0,1], [-1,-1], [-1,0], [-1,1]],
    knight: [[-1,-2], [-1,2], [1,-2], [1,2], 
          [-2,-1], [-2,1], [2,-1], [2,1]]
  }.freeze

  def initialize(color, type, start_pos)
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

  def get_moves
    move_list = MOVES[@type]
    possible_moves = move_list.map {|move| [current_pos[0] + move[0], current_pos[1] + move[1]]}
                      .select {|move| move[0].between?(1,8) && move[1].between?(1,8)}
  end
end