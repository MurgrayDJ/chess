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
    play_game
  end

  def play_game
    play_round
  end

  def play_round
    player_moves(@player1, "\u265A")
    player_moves(@player2, "\u2654")
  end

  def player_moves(player, king_sym)
    print "#{king_sym} #{player.name}'s turn #{king_sym}"
    print "#{player.name}, choose the square of the piece to move: "
    piece_valid = false
    until piece_valid
      square = get_square(player)
      piece = get_piece_from_square(square)
      if check_color(player, piece)
        confirmation = "Confirm moving #{piece.type} from #{square}? (Y/N): "
        response = get_valid_data(confirmation, nil, ["Y", "N"])
        if response == "Y" then piece_valid end
      end
    end
  end

  def check_color(player, piece)
    valid_piece = false
    if piece.respond_to?(:color)
      if piece.color == player.color 
        valid_piece = true
      else
        print "Other player's piece chosen. "
      end
    else
      print "Empty square. "
    end
    valid_piece
  end

  def get_square(player)
    square = ""
    until square.match?(/^[a-h]{1}[1-8]{1}$/i)
      print "Invalid square, try again: "
      square = gets.chomp
    end
    square
  end

  def get_piece_from_square(square)
    square_xy = @board.square_to_xy(square[0], square[1])
    x = square_xy[0]
    y = square_xy[1]
    @board.board[x][y]
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
    generate_noble_pieces(:black, 1, 8)
    generate_noble_pieces(:white, 8, 1)
    generate_pawns(:black, 2)
    generate_pawns(:white, 7)
  end

  def generate_noble_pieces(color, row, rank)
    noble_pieces = [
      rank,
      Rook.new(color, [row, 1]),
      Knight.new(color,[row, 2]),
      Bishop.new(color,[row, 3]),
      Queen.new(color,[row, 4]),
      King.new(color,[row, 5]),
      Bishop.new(color,[row, 6]),
      Knight.new(color,[row, 7]),
      Rook.new(color,[row, 8]),
      rank
    ]
    noble_pieces.each_with_index do |piece, idx|
      @board.board[row][idx] = noble_pieces[idx]
    end
  end

  def generate_pawns(color, row)
    (1..8).each do |file|
      pawn = Pawn.new(color, [row, file])
      @board.board[row][file] = pawn
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