require_relative 'board.rb'
require_relative 'player.rb'
Dir[File.join(__dir__, './pieces', '*.rb')].each { |file| require file }

class Chess
  attr_accessor :board
  attr_accessor :player1
  attr_accessor :player2
  DOTS = "\u2237"
  
  def initialize
    @board = Board.new()
    @player1 = Player.new("player1", :white)
    @player2 = Player.new("player2", :black)
  end

  def run_game
    print_title
    print_rules
    create_players
    generate_pieces
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
    puts
  end

  def create_players
    puts "Welcome Players! Please enter your names: "
    @player1.name = get_names(1)
    @player2.name = get_names(2)
  end

  def generate_pieces
    generate_pawns
  end

  def generate_pawns()
    (1..8).each do |file|
      black_pawn = Pawn.new(:black, [2,file])
      @player2.pieces << black_pawn
      @board.board[2][file] = black_pawn

      white_pawn = Pawn.new(:white, [7,file])
      @player1.pieces << white_pawn
      @board.board[7][file] = white_pawn
    end
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

# new_game = Chess.new()
# new_game.run_game