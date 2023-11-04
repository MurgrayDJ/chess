require_relative './board.rb'

class Chess
  attr_accessor :board
  DOTS = "\u2237"
  
  def initalize
    @board = Board.new()
  end

  def run_game
    print_title
  end

  def print_title
    title = ''
    title = add_title_dots(title)
    title << "CHESS "
    title = add_title_dots(title)
    puts title
  end

  def add_title_dots(title)
    (0..8).each do |num|
      title << "#{DOTS} "
    end
    title
  end
end