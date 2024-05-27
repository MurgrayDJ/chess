require_relative 'board.rb'
require_relative 'player.rb'
require_relative 'serializer.rb'
Dir[File.join(__dir__, './pieces', '*.rb')].each { |file| require file }

class Chess
  include Hashable
  attr_accessor :board
  attr_accessor :player1
  attr_accessor :player2
  attr_accessor :round
  attr_accessor :current_player
  attr_reader :serializer
  DOTS = "\u2237"
  
  def initialize
    @round = 0
    @board = Board.new()
    @player1 = Player.new("player1", :white)
    @player2 = Player.new("player2", :black)
    @current_player = @player1
    @serializer = Serializer.new()
  end

  def run_game
    print_title
    print_rules
    choice = choose_new_or_save
    if choice == "1"
      create_players
      generate_pieces
    else
      @serializer.find_save(self)
      puts "Welcome back #{@player1.name} and #{player2.name}!"
    end
    play_game
  end

  def play_game
    until game_over?
      @round += 1
      play_round
    end 
    end_game
  end

  def end_game
    puts "Thank you for playing!"
    exit!
  end

  def game_over?
    its_game_over = false
    if checkmate?
      @board.print_board
      puts "----------------------------------"
      puts "#{@current_player.name} has won with a checkmate!!!"
      puts "----------------------------------"
      its_game_over = true
    end
    its_game_over
  end

  def checkmate?
    is_checkmate = false
    other_player = (@current_player == @player1) ? @player2 : @player1
    if @board.captured_pieces[other_player.color].any? do |piece|
        is_checkmate = piece.is_a?(King)
      end
    end
    is_checkmate
  end

  def play_round
    if @round > 1 
      @current_player = (@current_player == @player1) ? @player2 : @player1
    end
    player_turn(@current_player)
  end

  def player_turn(player)
    @board.print_board
    puts "#{player.king_symbol} #{player.name}'s turn #{player.king_symbol}"
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
    make_move(square, square_val)
  end

  def make_move(old_square, piece)
    if piece.is_a?(Pawn) &&
      (piece.en_passant_round_start - @round) >= 2
      piece.delete_en_passant
    end
    moves = @board.check_surroundings(piece, piece.get_moves)
    converted_moves = show_user_moves(piece, moves)
    move_confirmed = false
    until move_confirmed
      prompt = "Enter one of the above squares to move: "
      new_square = get_valid_data(prompt, nil, converted_moves.map{|move| move.upcase})
      confirmation = "Confirm moving #{piece.type} to #{new_square}? (Y/N): "
      move_confirmed = confirm_choice?(confirmation)
    end
    @board.move_piece(old_square, new_square)
    if piece.is_a?(Pawn) 
      mark_en_passant(piece)
      try_promotion(piece, new_square) 
    else
      check_kings(piece)
    end
  end

  def check_kings(piece)
    king_location = ''
    (1..8).each do |x|
      (1..8).each do |y|
        if @board.board[x][y].is_a?(King) && @board.board[x][y].color != piece.color 
          king_location = [x,y]
        end
      end
    end
    moves = @board.check_surroundings(piece, piece.get_moves)
    piece_moves = moves
    if !moves.is_a?(Array) then piece_moves = moves.values.reduce([], :concat) end
    if piece_moves.include?(king_location)
      king_piece = @board.board[king_location[0]][king_location[1]]
      warn_player(@board.xy_to_square(king_location), king_piece)
    end
  end

  def warn_player(square, king_piece)
    player = (@current_player == @player1) ? @player2 : @player1
    @current_player = player
    @board.print_board
    puts "#{player.name} your king on #{square} is in check, you must move it."
    make_move(square, king_piece)
  end

  def mark_en_passant(pawn)
    old_spot = pawn.start_pos
    new_spot = pawn.current_pos
    if(pawn.color == :white)
      right_square = @board.board[new_spot[0]][new_spot[1] + 1]
      left_square = @board.board[new_spot[0]][new_spot[1] - 1]
    else
      right_square = @board.board[new_spot[0]][new_spot[1] - 1]
      left_square = @board.board[new_spot[0]][new_spot[1] + 1]
    end
    if ((old_spot[0] - new_spot[0]).abs == 2)
      if right_square.is_a?(Pawn)
        right_square.en_passant_update(:right, @round)
      elsif left_square.is_a?(Pawn)
        left_square.en_passant_update(:left, @round)
      end
    end
  end

  def try_promotion(pawn, new_square)
    if (pawn.color == :black && new_square[1] == "1") || 
      (pawn.color == :white && new_square[1] == "8")
      puts "Pawn promotion available! Pawn can be promoted to a queen, rook, bishop, or knight. "
      promo_confirmed = false
      until promo_confirmed
        prompt = "Select a piece type to upgrade to: "
        new_piece_type = get_valid_data(prompt, nil, ["queen", "rook", "bishop", "knight"])
        confirmation = "Confirm promoting pawn to #{new_piece_type}? (Y/N): "
        promo_confirmed = confirm_choice?(confirmation)
      end
      promote_pawn(pawn, new_piece_type.capitalize)
    end
  end

  def promote_pawn(pawn, new_piece_type)
    new_piece = Object.const_get(new_piece_type).new(pawn.color, pawn.start_pos)
    @board.board[pawn.current_pos[0]][pawn.current_pos[1]] = new_piece
  end

  def convert_moves(moves)
    converted_moves = ''
    if moves.is_a?(Array)
      converted_moves = moves.map{|move| @board.xy_to_square(move)}
    else
      converted_moves = moves.values.reduce([], :concat).map{|move| @board.xy_to_square(move)}
    end
    converted_moves
  end

  def show_user_moves(piece, moves)
    print "This #{piece.type} can be moved to: "
    converted_moves = convert_moves(moves)
    puts converted_moves.join(" ")
    converted_moves
  end

  def confirm_choice?(confirmation)
    response = get_valid_data(confirmation, nil, ["Y", "N"])
    if response.casecmp?("Y")
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
      quit_save_or_help(square)
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
    puts " #{DOTS} The only way to win is to capture the opponent's king. Draws are not "
    puts "    enforced."
    puts " #{DOTS} Type 'save' to save at any time." 
    puts " #{DOTS} Type 'exit' or 'quit' to get choice to save at any time."
    puts " #{DOTS} Type 'help' at any time to repeat this message.\n\n"
    puts "#{DOTS} " * 21 
    puts
  end

  def choose_new_or_save
    puts "#{DOTS} " * 21 
    puts "Would you like to: "
    puts "   1. Start a new game"
    puts "            OR"
    puts "   2. Open a saved game"
    puts "*Save files are deleted after being reopened."
    puts
    action_prompt = "Please enter 1 or 2 for an action: "
    action_choices = %w(1 2)
    get_valid_data(action_prompt, nil, action_choices)
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
    name_confirmed = false
    until name_confirmed
      print "Player #{player_num} name: "
      name = gets.chomp
      quit_save_or_help(name)
      confirmation = "Confirm name #{name}? (Y/N): "
      name_confirmed = confirm_choice?(confirmation)
    end
    name
  end

  def quit_save_or_help(user_input)
    if user_input.casecmp?("exit") || user_input.casecmp?("quit")
      confirmation = "Do you want to save this game? (Y/N): "
      choice = confirm_choice?(confirmation)
      choice ? @serializer.save_game(self) : end_game
      exit!
    elsif user_input.casecmp?("help")
      print_rules
    elsif user_input.casecmp?("save")
      @serializer.save_game(self)
    end
  end

  def get_valid_data(prompt, response, valid_responses) 
    if response.nil?
      print prompt
      response = gets.chomp
    else
      valid_responses.each do |valid_response|
        if response.casecmp?(valid_response)
          return response
        else
          quit_save_or_help(response)
        end
      end
      response = nil
    end
    response = get_valid_data(prompt, response, valid_responses)  
  end
end

# new_game = Chess.new()
# new_game.run_game