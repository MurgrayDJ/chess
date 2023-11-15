
class Player
  attr_accessor :name
  attr_accessor :pieces
  attr_reader :color

  def initialize(name, color)
    @name = name
    @color = color
    @pieces = []
  end
end
