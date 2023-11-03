require_relative '../../lib/pieces/pawn.rb'

RSpec.describe Pawn do

  describe "#get_moves" do

    #Pawn
    context "f2 [7,6] w_pawn is in starting position with no piece in front" do
      before {@w_pawn = described_class.new(:white, [7,6])}
      it "should return a hash with moves [5,6], [6,6]" do
        expect(@w_pawn.get_moves.values.reduce([], :concat)).to match_array([[5,6],[6,6]])
      end
    end

    context "c7 [2,3] b_pawn is in starting position" do
      before {@b_pawn = described_class.new(:black, [2,3])}
      it "should return a hash with moves [3,3], [4,3]" do
        expect(@b_pawn.get_moves.values.reduce([], :concat)).to match_array([[3,3],[4,3]])
      end
    end
  end
end