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
    create_players
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
    puts " #{DOTS} The White side is whichever one that starts on ranks 1 and 2 "
    puts "   (towards the bottom of the screen.)"
    puts " #{DOTS} Player 1 is White and goes first. Then players alternate turns."
    puts " #{DOTS} When it's your turn to play, please enter the file then rank of the "
    puts "   piece you would like to move. (e.g., e2, f7)"
    puts " #{DOTS} Then enter the file then rank of the space you'd like to move your "
    puts "   piece to."
    puts " #{DOTS} Type 'exit' to leave at any time."
    puts " #{DOTS} Type 'help' at any time to repeat this message.\n\n"
    puts "#{DOTS} " * 21 
  end

  def create_players
    puts "Welcome Players! Please enter your names: "
    @player1 = Player.new(get_names(1), :white)
    @player2 = Player.new(get_names(2), :black)
  end

  def get_names(player_num)
    name = nil
    while name.nil?
      name = confirm_name(player_num)
    end
    name
  end

  def confirm_name(player_num)
    print "Player #{player_num} name: "
    name = gets.chomp
    confirmation = "Confirm name #{name}? (Y/N): "
    response = get_valid_data(confirmation, nil, ["Y", "N"])
    if response == "N" then name = nil end
    name
  end

  def get_valid_data(prompt, response, valid_responses) 
    if response.nil?
      print prompt
      response = gets.chomp
    else
      response = response.upcase
      valid_responses.each do |valid_response|
        if response == valid_response
          return response
        elsif response == "EXIT"
          puts "Thank you for playing!"
          exit!
        elsif response == "HELP"
          print_rules
          break
        end
      end
      response = nil
    end
    response = get_valid_data(prompt, response, valid_responses)  
  end
end