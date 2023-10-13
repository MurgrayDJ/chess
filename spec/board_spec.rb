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
        @board_class.board[1][5] = king
        @board_class.move_piece([1,5], [2,6])
        expect(@board_class.board[2][6]).to eq(king)
      end
    end
  end

  describe "#update_old_spot" do
    let(:sym) {"\u265a"}
    context "there's a king symbol on g3 [6,7]" do
      it "should remove the symbol and put a space there" do
        @board_class.board[6][7] = sym
        @board_class.update_old_spot(6,7)
        expect(@board_class.board[6][7]).to eq(" ")
      end
    end

    context "there's a king symbol on b1 [8,2]" do
      it "should remove the symbol and put dots there" do
        @board_class.board[8][2] = sym
        @board_class.update_old_spot(8,2)
        expect(@board_class.board[8][2]).to eq(DOTS)
      end
    end

    context "there's a king symbol on e4 [5,5]" do
      it "should remove the symbol and put dots there" do
        @board_class.board[5][5] = sym
        @board_class.update_old_spot(5,5)
        expect(@board_class.board[5][5]).to eq(DOTS)
      end
    end

    context "there's a king symbol on b6 [3,2]" do
      it "should remove the symbol and put a space there" do
        @board_class.board[3][2] = sym
        @board_class.update_old_spot(3,2)
        expect(@board_class.board[3][2]).to eq(" ")
      end
    end
  end

  describe "#check_surroundings" do
    context "king at e8 [1,5], pawn at f7 [2,6]"
      let(:king) {double(symbol: "\u265a",type: :black)}
      let(:pawn) {double(symbol: "\u2659",type: :black)}
      it "should remove [2,6] from the moves list" do
        @board_class.board[1][5] = king
        @board_class.board[2][6] = pawn
        move_list = [2,4],[2,5],[2,6],[1,4],[1,6]
        @board_class.check_surroundings(king, move_list)
        expect(move_list).not_to include([2,6])
      end
  end
end