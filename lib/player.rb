
class Player
  attr_accessor :name
  attr_accessor :pieces
  attr_accessor :pieces_taken
  attr_reader :color

  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
    @pieces_taken = []
  end
end
