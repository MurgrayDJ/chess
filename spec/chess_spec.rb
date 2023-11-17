require_relative '../lib/chess.rb'
require_relative '../lib/player.rb'
Dir[File.join(__dir__, '../lib/pieces', '*.rb')].each { |file| require file }

RSpec.describe Chess do
  before { @game = described_class.new }
  DOTS = "\u2237"

  describe "#print_title" do
    context "title is printed surrounded by dots for flare" do
      it "should print the title" do
        @game.print_title
      end
    end
  end

  describe "#print_rules" do
    context "rules are printed with dots for bullet points" do
      it "should print the rules" do
        @game.print_title
        @game.print_rules
      end
    end
  end

  describe '#get_names' do
    context 'player1 enters name then confirms it' do
      it 'should return the player 1 name' do
        allow(@game).to receive(:gets).and_return("Bob\n", "Y\n")
        expect(@game.get_names(1)).to eq("Bob")
      end
    end

    context 'player2 enters name then changes it' do
      it 'should return the second player 2 name' do
        allow(@game).to receive(:gets).and_return("Mumu\n", "n\n", "Linda\n", "Y\n")
        expect(@game.get_names(2)).to eq("Linda")
      end
    end

    context 'player1 enters invalid text for name confirmation' do
      it 'should still return the first name after eventual yes' do
        allow(@game).to receive(:gets).and_return(
          "Bob\n", "kdyfj\n", "2836%(^*\n", "banana34\n", "Y\n")
        expect(@game.get_names(1)).to eq("Bob")
      end
    end
  end

  describe "#generate_pawns" do
    context 'Generates pawns for players' do
      before do 
        @game.generate_pawns(:black, 2) 
        @game.generate_pawns(:white, 7) 
      end
      
      it 'should set row 2 [rank 7] of the board to black pawns' do
        result = @game.board.board[2].all? do |square| 
          square.instance_of?(Integer) || square.color == :black
        end
        expect(result).to be true
      end

      it 'should set row 7 [rank 2] of the board to white pawns' do
        result = @game.board.board[2].none?{|square| square.instance_of?(String)}
        expect(result).to be true
      end
    end
  end

  describe "#generate_noble_pieces" do
    context 'generate pieces for black' do
      before { @game.generate_noble_pieces(:black, 1, 8) }
      it "should have a piece on a1" do
        expect(@game.board.board[1][1].respond_to?(:color)).to be true
      end
    end

    context 'generate pieces for black' do
      before { @game.generate_noble_pieces(:white, 8, 1) }
      it "should have a piece on h8" do
        expect(@game.board.board[8][8].respond_to?(:color)).to be true
      end
    end
  end

  describe "#generate_pieces" do
    before { @game.generate_pieces }
    context "generate all the board pieces" do
      it "should have all pieces on the board" do
        puts
        @game.board.print_board
      end
    end
  end

  describe "#get_square" do
    context "player enters correctly formatted square (h3)" do
      it "should return the square (h3)" do
        allow(@game).to receive(:gets).and_return("h3\n")
        expect(@game.get_square("h3")).to eq("h3")
      end
    end

    context "player enters square with capital letter (E6)" do
      it "should return the square (E6)" do
        allow(@game).to receive(:gets).and_return("E6\n")
        expect(@game.get_square("E6")).to eq("E6")
      end
    end

    context "player enters square with invalid rank (a9)" do
      it "should only return once a valid square is entered (a8)" do
        allow(@game).to receive(:gets).and_return("a9\n", "a8\n")
        expect(@game.get_square("a9")).to eq("a8")
      end
    end

    context "player enters square with invalid file (k4)" do
      it "should only return once a valid square is entered (c4)" do
        allow(@game).to receive(:gets).and_return("k4\n", "c4\n")
        expect(@game.get_square("k4")).to eq("c4")
      end
    end

    context "player enters nonsense value (lkd4#$%fs)" do
      it "should only return once a valid square is entered (d4)" do
        allow(@game).to receive(:gets).and_return("lkd4#$%fs\n", "d4\n")
        expect(@game.get_square("lkd4#$%fs")).to eq("d4")
      end
    end
  end

  describe "#get_square_val" do
    before { @game.generate_pieces }
    context "there is a piece on square b1" do
      it "should return the piece (a Knight)" do
        square = "b1"
        square_val = @game.get_square_val(square)
        expect(square_val.is_a?(Knight)).to be true
      end
    end

    context "there is no piece on the square" do
      it "should return a value of type String (a space)" do
        square = "e5"
        square_val = @game.get_square_val(square)
        expect(square_val.is_a?(String)).to be true
      end

      it "should return a value of type String (dots)" do
        square = "g6"
        square_val = @game.get_square_val(square)
        expect(square_val.is_a?(String)).to be true
      end
    end
  end

  describe "#right_color?" do
    player1 = Player.new("Zari", :white)
    player2 = Player.new("Lily", :black)

    context "player wants to move their own piece" do
      it "should return true" do
        king = King.new(:black, [1,5])
        expect(@game.right_color?(player2, king)).to be true
      end
    end

    context "player tries to move other player's piece" do
      it "should print a message about other player's piece" do
        queen = Queen.new(:white, [8,4])
        expect do 
          @game.right_color?(player2, queen)
        end.to output(a_string_including("Other player's piece chosen. ")).to_stdout
      end
      
      it "should return false" do
        queen = Queen.new(:white, [8,4])
        expect(@game.right_color?(player2, queen)).to be false
      end
    end
  end

  describe "#player_moves" do
    before { @game.generate_pieces }
    player1 = Player.new("Zari", :white)
    player2 = Player.new("Lily", :black)

    context "Player tries to move their own pawn" do
      it "should call the move_piece method" do
        allow(@game).to receive(:gets).and_return("c2\n", "Y\n")
        expect(@game).to receive(:move_piece)
        @game.player_moves(player1, "\u265A")
      end
    end

    context "Player tries to move another player's piece" do
      it "should reprompt them, then move the second piece" do
        allow(@game).to receive(:gets).and_return("d2\n", "f7\n", "Y\n")
        expect(@game).to receive(:move_piece)
        @game.player_moves(player2, "\u2654")
      end
    end

    context "Player tries to enter empty square" do
      it "should reprompt them, then move the second piece" do
        allow(@game).to receive(:gets).and_return("g5\n", "h2\n", "Y\n")
        expect(@game).to receive(:move_piece)
        @game.player_moves(player1, "\u265A")
      end
    end

    context "Player tries to move trapped king" do
      it "should reprompt them, then move the second piece" do
        allow(@game).to receive(:gets).and_return("e1\n", "g1\n", "Y\n")
        expect(@game).to receive(:move_piece)
        @game.player_moves(player1, "\u265A")
      end
    end

    context "Player tries to move trapped queen" do
      it "should reprompt them, then move the second piece" do
        allow(@game).to receive(:gets).and_return("d1\n", "b1\n", "Y\n")
        expect(@game).to receive(:move_piece)
        @game.player_moves(player1, "\u265A")
      end
    end

    context "Player tries 3 invalid squares" do
      it "won't move on until they enter the fourth valid one" do
        allow(@game).to receive(:gets).and_return("b1\n", "c6\n", "banana\n", "e7\n", "Y\n")
        expect(@game).to receive(:move_piece)
        @game.player_moves(player2, "\u2654")
      end
    end
  end

  describe "#show_user_moves" do
    context "Bishop move attempt with enemy knight in way" do
      it "should not include the spaces after that piece" do
        c8_bishop = Bishop.new(:black, [1,3])
        knight = Knight.new(:white, [8,7])
        @game.board.board[1][3] = c8_bishop
        @game.board.board[4][6] = knight
        moves = @game.board.check_surroundings(c8_bishop, c8_bishop.get_moves)
        expect(@game.show_user_moves(c8_bishop, moves)).to match_array(["b7","a6","d7","e6","f5"])
      end
    end
  end

  describe "#move_piece" do 
    context "Player moves b1 knight to a3 (full board)" do
      before { @game.generate_pieces }
      it "should move the knight to a3" do
        b1_knight = @game.board.board[8][2]
        allow(@game).to receive(:gets).and_return("a3\n", "Y\n")
        @game.move_piece("b1", b1_knight)
        expect(@game.board.board[6][1].is_a?(Knight)).to be true
      end
    end

    context "Player moves d8 queen to h4 (empty board)" do
      it "should move the queen to h4" do
        d8_queen = Queen.new(:black, [1,4])
        @game.board.board[1][4] = d8_queen
        allow(@game).to receive(:gets).and_return("h4\n", "Y\n")
        @game.move_piece("d8", d8_queen)
        expect(@game.board.board[5][8].is_a?(Queen)).to be true
      end
    end

    context "Player moves rook (pawn is in front)" do
      it "should move the rook all the way to the left" do
        h1_rook = Rook.new(:white, [8,8])
        h2_pawn = Pawn.new(:white, [7,8])
        @game.board.board[8][8] = h1_rook
        @game.board.board[7][8] = h2_pawn
        allow(@game).to receive(:gets).and_return("a1\n", "Y\n")
        @game.move_piece("h1", h1_rook)
        expect(@game.board.board[8][1].is_a?(Rook)).to be true
      end
    end

    context "Player changes mind about moving pawn to a spot (full board)" do
      before { @game.generate_pieces }
      it "should move the pawn to second spot" do
        g7_pawn = @game.board.board[2][7]
        allow(@game).to receive(:gets).and_return("g6\n", "N\n", "g5\n", "Y\n")
        @game.move_piece("g7", g7_pawn)
        expect(@game.board.board[4][7].is_a?(Pawn)).to be true
      end
    end

    context "Bishop captures enemy knight " do
      before do
        c8_bishop = Bishop.new(:black, [1,3])
        knight = Knight.new(:white, [8,7])
        @game.board.board[1][3] = c8_bishop
        @game.board.board[4][6] = knight
        allow(@game).to receive(:gets).and_return("f5\n", "Y\n")
        @game.move_piece("c8", c8_bishop)
      end

      it "should have the Bishop in the enemy's spot" do
        expect(@game.board.board[4][6].is_a?(Bishop)).to be true
      end
      
      it "should add the knight to the captured_pieces hash" do
        expect(@game.board.captured_pieces[:white].length).to be 1
      end
    end
  end

  describe "#try_promotion" do
    context "White pawn makes it to d8" do
      it "should let the user upgrade it to a Queen" do
        d2_pawn = Pawn.new(:white, [7,4])
        d2_pawn.current_pos = [1,4]
        @game.board.board[1][4] = d2_pawn
        allow(@game).to receive(:gets).and_return("queen\n", "Y\n")
        @game.try_promotion(d2_pawn, "d8")
        expect(@game.board.board[1][4].is_a?(Queen)).to be true
      end
    end

    context "Black pawn makes it to b1" do
      it "should let the player upgrade it to a Knight" do
        b7_pawn = Pawn.new(:black, [2,2])
        b7_pawn.current_pos = [8,2]
        @game.board.board[8][2] = b7_pawn
        allow(@game).to receive(:gets).and_return("knight\n", "Y\n")
        @game.try_promotion(b7_pawn, "b1")
        expect(@game.board.board[8][2].is_a?(Knight)).to be true
      end
    end

    context "White pawn moves to e4" do
      it "should do nothing" do
        e2_pawn = Pawn.new(:white, [7,5])
        e2_pawn.current_pos = [5,5]
        @game.board.board[5][5] = e2_pawn
        @game.try_promotion(e2_pawn, "e4")
        expect(@game.board.board[5][5].is_a?(Pawn)).to be true
      end
    end
  end

  describe "#mark_en_passant" do
   context "black pawn makes left white pawn eligible for en_passant" do
    it "should mark left white pawn eligible" do
      g7_pawn = Pawn.new(:black, [2,7])
      f2_pawn = Pawn.new(:white, [7,6])
      @game.board.board[2][7] = g7_pawn #g7
      @game.board.board[4][6] = f2_pawn #f5
      allow(@game).to receive(:gets).and_return("g5\n", "Y\n")
      @game.move_piece("g7", g7_pawn)
      expect(f2_pawn.en_passant_available).to be true
    end
   end

   context "black pawn makes right white pawn eligible for en_passant" do
    it "should mark right white pawn eligible" do
      g7_pawn = Pawn.new(:black, [2,7])
      h2_pawn = Pawn.new(:white, [7,8])
      @game.board.board[2][7] = g7_pawn #g7
      @game.board.board[4][8] = h2_pawn #h5
      allow(@game).to receive(:gets).and_return("g5\n", "Y\n")
      @game.move_piece("g7", g7_pawn)
      expect(h2_pawn.en_passant_available).to be true
    end
   end

   context "white pawn makes left black pawn eligible for en_passant" do
    it "should mark left black pawn eligible" do
      c2_pawn = Pawn.new(:white, [7,3])
      b7_pawn = Pawn.new(:black, [2,2])
      @game.board.board[7][3] = c2_pawn #c2
      @game.board.board[5][2] = b7_pawn #b4
      @game.board.print_board
      allow(@game).to receive(:gets).and_return("c4\n", "Y\n")
      @game.move_piece("c2", c2_pawn)
      @game.board.print_board
      expect(b7_pawn.en_passant_available).to be true
    end
   end

   context "white pawn makes right black pawn eligible for en_passant" do
    it "should mark right black pawn eligible" do
      c2_pawn = Pawn.new(:white, [7,3])
      d7_pawn = Pawn.new(:black, [2,4])
      @game.board.board[7][3] = c2_pawn #c2
      @game.board.board[5][4] = d7_pawn #d4
      @game.board.print_board
      allow(@game).to receive(:gets).and_return("c4\n", "Y\n")
      @game.move_piece("c2", c2_pawn)
      @game.board.print_board
      expect(d7_pawn.en_passant_available).to be true
    end
   end
  end
end