require_relative '../lib/board.rb'

RSpec.describe Board do
  before { @board_class = described_class.new }

  describe "#print_board" do
    context "board is empty" do 
      it "should print an empty board" do
        @board_class.print_board
      end
    end
  end

  describe "#move_piece" do
    context "king is in starting position" do
      let(:king) {double(symbol: "\u265a", current_pos: [1,5])}
      it "should have the king in a different position" do
        @board_class.print_board
        @board_class.board[1][5] = king
        @board_class.print_board
        @board_class.move_piece([1,5], [2,6])
        @board_class.print_board
        expect(@board_class.board[2][6]).to eq(king)
      end
    end
  end
end