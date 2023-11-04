require_relative '../lib/chess.rb'

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
end