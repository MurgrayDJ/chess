require_relative '../../lib/pieces/queen.rb'

RSpec.describe Queen do
  before {@b_queen = described_class.new(:black, [1,4])}

  # describe "#get_moves" do
  #   before {@w_pawn = described_class.new(:white, [7,6])}

  #   #Pawn
  #   context "f2 [7,6] pawn is in starting position with no piece in front" do
  #     it "should return a list with 1 move" do
  #       expect(@w_pawn.get_moves).to match_array([[8,6]])
  #     end
  #   end
  # end

  describe "#generate_moves" do
    context "New queen is created" do
      it "should generate her whole move list" do
        expect(@b_queen.moves.length).to eq(56)
      end
    end
  end
end