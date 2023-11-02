require_relative '../../lib/pieces/bishop.rb'

RSpec.describe Bishop do
  before {@w_bishop = described_class.new(:white, [8,1])}

  describe "#get_moves" do
    context "w_rook is in starting position f1 [8,7]" do
      it "should generate a hash list with 7 moves" do
        expect(@w_bishop.get_moves.values.reduce([], :concat).length).to eq(7)
      end
    end
  end
end