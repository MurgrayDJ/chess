require_relative '../../lib/pieces/pawn.rb'

RSpec.describe Pawn do

  describe "#get_moves" do
    before {@w_pawn = described_class.new(:white, [7,6])}

    #Pawn
    context "f2 [7,6] w_pawn is in starting position with no piece in front" do
      it "should return a hash with 2 moves" do
        expect(@w_pawn.get_moves.values.reduce([], :concat)).to match_array([[5,6],[6,6]])
      end
    end
  end
end