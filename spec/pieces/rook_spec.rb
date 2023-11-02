require_relative '../../lib/pieces/rook.rb'

RSpec.describe Rook do
  before {@w_rook = described_class.new(:white, [8,1])}

  describe "#get_moves" do
    context "w_rook is in starting position a1 [8,1]" do
      it "should generate a hash list with 14 moves" do
        expect(@w_rook.get_moves.values.reduce([], :concat).length).to eq(14)
      end
    end
  end
end