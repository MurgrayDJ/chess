require_relative './board.rb'

class Chess
  attr_accessor :board
  DOTS = "\u2237"
  
  def initalize
    @board = Board.new()
  end

  def run_game
    print_title
    print_rules
  end

  def print_title
    puts
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

  def print_rules
    puts "\nHow to play: "
    puts " #{DOTS} If you don't already know how to play chess, please reference other "
    puts "   material for overall instructions"
    puts " #{DOTS} When it's your turn to play, please enter the file then rank of the "
    puts "   piece you would like to move. (e.g., e2, f7)"
    puts " #{DOTS} Then enter the file then rank of the space you'd like to move your "
    puts "   piece to."
    puts " #{DOTS} Type 'exit' to leave at any time."
    puts " #{DOTS} Type 'help' at any time to repeat this message.\n\n"
    puts "#{DOTS} " * 21 
  end
end