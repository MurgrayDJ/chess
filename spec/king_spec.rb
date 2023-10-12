require_relative '../lib/pieces/king.rb'

RSpec.describe King do
  before {@blk_king = described_class.new(:black, [1,5])}

  describe "#get_moves" do
    context "he is in starting position with no other pieces" do
      it "should return a list of next moves within the board" do
        expect(@blk_king.get_moves).to eq([[2,4],[2,5],[2,6],[1,4],[1,6]])
      end
    end
  end
end