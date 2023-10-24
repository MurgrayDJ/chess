require_relative '../lib/pieces/king.rb'

RSpec.describe King do

  describe "#get_moves" do
    before {@blk_king = described_class.new(:black, [1,5])}

    #King
    context "king is in starting position with no other pieces" do
      it "should return a list of the 5 next possible next moves" do
        expect(@blk_king.get_moves).to match_array([[2,4],[2,5],[2,6],[1,4],[1,6]])
      end
    end

    context "king is in the middle of the board with no other pieces" do
      it "should return a list of all 8 surrounding moves" do
        @blk_king.current_pos = [4,4]
        expect(@blk_king.get_moves).to match_array([[5,3],[5,4],[5,5],[4,3],[4,5],[3,3],[3,4],[3,5]])
      end
    end
  end
end