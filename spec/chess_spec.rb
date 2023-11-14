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

    context "Player tries to move their own piece" do
      it "should call the move_piece method" do
        allow(@game).to receive(:gets).and_return("c1\n", "Y\n")
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
        allow(@game).to receive(:gets).and_return("g5\n", "h1\n", "Y\n")
        expect(@game).to receive(:move_piece)
        @game.player_moves(player1, "\u265A")
      end
    end
  end
end