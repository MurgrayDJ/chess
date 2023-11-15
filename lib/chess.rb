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
    square = gets.chomp
    square_val = nil
    confirmed_piece = false
    until confirmed_piece
      square = get_square(square)
      square_val = get_square_val(square)
      if piece_valid?(player, square_val)
        confirmation = "Confirm moving #{square_val.type} from #{square}? (Y/N): "
        if confirm_choice?(confirmation) then confirmed_piece = true end
      else
        square = ''
      end
    end
    move_piece(square, square_val)
  end

  def move_piece(old_square, piece)
    moves = @board.check_surroundings(piece, piece.get_moves)
    converted_moves = show_user_moves(piece, moves)
    move_confirmed = false
    until move_confirmed
      prompt = "Enter one of the above squares to move: "
      new_square = get_valid_data(prompt, nil, converted_moves.map{|move| move.upcase}).downcase
      confirmation = "Confirm moving #{piece.type} to #{new_square}? (Y/N): "
      move_confirmed = confirm_choice?(confirmation)
    end
    @board.move_piece(old_square, new_square)
  end

  def show_user_moves(piece, moves)
    print "This #{piece.type} can be moved to: "
    converted_moves = ''
    if moves.is_a?(Array)
      converted_moves = moves.map{|move| @board.xy_to_square(move)}
    else
      converted_moves = moves.values.reduce([], :concat).map{|move| @board.xy_to_square(move)}
    end
    puts converted_moves.join(" ")
    converted_moves
  end

  def confirm_choice?(confirmation)
    response = get_valid_data(confirmation, nil, ["Y", "N"])
    if response == "Y"
      true 
    else
      false
    end
  end

  def piece_valid?(player, square_val)
    if square_val.is_a?(Piece)
      piece = square_val
      if right_color?(player, piece) 
        if has_valid_moves?(piece)
          return true
        end
      end
    else
      print "No piece there. "
      false
    end
  end

  def has_valid_moves?(piece)
    moves = @board.check_surroundings(piece, piece.get_moves)
    if moves.is_a?(Hash)
      moves = moves.values.reduce([], :concat)
    end
    if moves.length != 0
      true
    else
      print "No valid moves available. "
      false
    end
  end

  def right_color?(player, piece)
    if player.color == piece.color
      true
    else
      print "Other player's piece chosen. "
      false
    end
  end

  def get_square(square)
    until square.match?(/^[a-h]{1}[1-8]{1}$/i)
      print "Invalid square, try again: "
      square = gets.chomp
    end
    square
  end

  def get_square_val(square)
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