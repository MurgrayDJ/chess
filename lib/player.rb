
class Player
  attr_accessor :name
  attr_accessor :pieces
  attr_reader :king_symbol
  attr_reader :color

  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
    @king_symbol = (color == :white) ? "\u265A" : "\u2654"
  end
end
