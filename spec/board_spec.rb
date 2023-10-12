require_relative '../lib/board.rb'

RSpec.describe Board do
  before { @board_class = described_class.new }
  DOTS = "\u2237"

  describe "#print_board" do
    context "board is empty" do 
      it "should print an empty board" do
        @board_class.print_board
      end
    end
  end

  describe "#move_piece" do
    context "king is moving from e8 [1,5] to f7 [2,6]" do
      let(:king) {double(symbol: "\u265a", current_pos: [1,5])}
      it "should have the king in f7 [2,6]" do
        @board_class.print_board
        @board_class.board[1][5] = king
        @board_class.print_board
        @board_class.move_piece([1,5], [2,6])
        @board_class.print_board
        expect(@board_class.board[2][6]).to eq(king)
      end
    end
  end

  describe "#update_old_spot" do
    context "there's a king symbol on g3 [6,7]" do
      it "should remove the symbol and put a space there" do
        sym = "\u265a"
        @board_class.board[6][7] = sym
        @board_class.print_board
        @board_class.update_old_spot(6,7)
        @board_class.print_board
        expect(@board_class.board[6][7]).to eq(" ")
      end
    end
  end
end