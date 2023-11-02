require_relative '../../lib/pieces/queen.rb'

RSpec.describe Queen do
  before {@b_queen = described_class.new(:black, [1,4])}

  # describe "#generate_moves" do
  #   context "New queen is created" do
  #     it "should generate her whole move list" do
  #       expect(@b_queen.moves.length).to eq(56)
  #     end
  #   end
  # end

  describe "#get_moves" do
    context "b_queen is in starting position" do
      it "should generate a hash list with 21 moves" do
        expect(@b_queen.get_moves.values.reduce([], :concat).length).to eq(21)
      end
    end
  end
end