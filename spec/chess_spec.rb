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
end