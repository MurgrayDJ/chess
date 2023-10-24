require_relative '../../lib/pieces/pawn.rb'

RSpec.describe Pawn do

  describe "#get_moves" do
    before {@w_pawn = described_class.new(:white, [7,6])}

    #Pawn
    context "f2 [7,6] pawn is in starting position with no piece in front" do
      it "should return a list with 1 move" do
        expect(@w_pawn.get_moves).to match_array([[8,6]])
      end
    end
  end
end