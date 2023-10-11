

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
    set_symbol
  end

  def set_symbol
    if @type == :black
      @symbol = "\u265a"
    else
      @symbol = "\u2654"
    end
  end
end