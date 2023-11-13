require_relative '../lib/chess.rb'
require_relative '../lib/player.rb'

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
    context "player enters correctly formatted square" do
      it "should return the square" do
        allow(@game).to receive(:gets).and_return("h3\n")
        player1 = Player.new("Zari", :white)
        expect(@game.get_square(player1)).to eq("h3")
      end
    end
  end
end