require_relative '../../lib/pieces/knight.rb'

RSpec.describe Knight do

  describe "#get_moves" do
    before {@w_knight = described_class.new(:white, [9,2])}

    #Knight
    context "b1 [9,2] knight is in starting position with no other pieces" do
      it "should return a list with only 3 moves" do
        expect(@w_knight.get_moves).to match_array([[7,1],[7,3],[8,4]])
      end
    end
  end
end