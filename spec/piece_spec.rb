require_relative '../lib/piece.rb'

RSpec.describe Piece do

  describe "#get_moves" do
    before {@blk_king = described_class.new(:black, :king, [1,5])}
    before {@w_knight = described_class.new(:white, :knight, [9,2])}

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

    context "b1 [9,2] knight is in starting position with no other pieces" do
      it "should return a list with only 3 moves" do
        expect(@w_knight.get_moves).to match_array([[7,1],[7,3],[8,4]])
      end
    end
  end
end