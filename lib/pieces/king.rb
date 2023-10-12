

class King
  attr_accessor :symbol
  attr_accessor :type
  attr_accessor :name
  attr_accessor :start_pos
  attr_accessor :current_pos
  MOVES = [[1,-1], [1,0], [1,1],
           [0,-1], [0,1], 
           [-1,-1], [-1,0], [-1,1]].freeze
  
  def initialize(type, start_pos)
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
    possible_moves = MOVES.map {|move| [current_pos[0] + move[0], current_pos[1] + move[1]]}
                      .select {|move| move[0].between?(1,8) && move[1].between?(1,8)}
  end
end