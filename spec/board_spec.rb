require_relative '../lib/board.rb'
Dir[File.join(__dir__, '../lib/pieces', '*.rb')].each { |file| require file }

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
    context "king at e8 [1,5], pawn at f7 [2,6]" do
      let(:king) {double(symbol: "\u265a",color: :black)}
      let(:pawn) {double(symbol: "\u2659",color: :black)}
      it "should remove [2,6] from the moves list" do
        @board_class.board[1][5] = king
        @board_class.board[2][6] = pawn
        move_list = [[2,4],[2,5],[2,6],[1,4],[1,6]]
        @board_class.check_surroundings(king, move_list)
        expect(move_list).not_to include([2,6])
      end
    end

    context "king at a8 [1,1], pawns at a7 [2,1], b7 [2,2], b8 [1,2]" do
      let(:king) {double(symbol: "\u265a",color: :black)}
      let(:pawn1) {double(symbol: "\u2659",color: :black)}
      let(:pawn2) {double(symbol: "\u2659",color: :black)}
      let(:pawn3) {double(symbol: "\u2659",color: :black)}
      it "should return an empty list" do
        @board_class.board[1][1] = king
        @board_class.board[2][1] = pawn1
        @board_class.board[2][2] = pawn2
        @board_class.board[1][2] = pawn3
        move_list = [[2,1],[2,2],[1,2]]
        @board_class.check_surroundings(king, move_list)
        expect(move_list).to be_empty
      end
    end

    context "b_queen at d8 [1,4], pawn at e7 [2,5]" do
      before {@b_queen = Queen.new(:black, [1,4])}
      before {@b_pawn = Pawn.new(:black, [2,5])}
      it "should return a list without the southeast list" do
        @board_class.board[1][4] = @b_queen
        @board_class.board[2][5] = @b_pawn
        move_list = @b_queen.get_moves
        @board_class.check_surroundings(@b_queen, move_list)
        expect(move_list.values.reduce([], :concat)).not_to include([2,5],[3,6],[4,7],[5,8])
      end
    end

    context "b_queen at d8 [1,4], w pawn at d7 [2,4]" do
      before {@b_queen = Queen.new(:black, [1,4])}
      before {@w_pawn = Pawn.new(:white, [2,5])}
      it "should return a list with only one south item" do
        @board_class.board[1][4] = @b_queen
        @board_class.board[2][4] = @w_pawn
        move_list = @b_queen.get_moves
        @board_class.check_surroundings(@b_queen, move_list)
        expect(move_list.values.reduce([], :concat)).to not_include([4,4],[5,4],[6,4],[7,4],[8,4])
        .and include([2,5])
      end
    end

    context "w_rook at a1 [8,1], w_knight at b1 [8,2]" do
      before {@w_rook = Rook.new(:white, [8,1])}
      before {@w_knight = Knight.new(:white, [8,2])}
      it "should return a list with only the northern moves" do
        @board_class.board[8][1] = @w_rook
        @board_class.board[8][2] = @w_knight
        move_list = @w_rook.get_moves
        @board_class.check_surroundings(@w_rook, move_list)
        expect(move_list.values.reduce([], :concat)).to match_array([[7,1],[6,1],[5,1],[4,1],[3,1],[2,1],[1,1]])
      end
    end

    context "b_bishop at d4 [5,4], w_pawn at f6 [3,6]" do
      before {@b_bishop = Bishop.new(:black, [5,4])}
      before {@w_pawn = Pawn.new(:white, [3,6])}
      it "should return a list with 11 moves" do
        @board_class.board[5][4] = @b_bishop
        @board_class.board[3][6] = @w_pawn
        move_list = @b_bishop.get_moves
        @board_class.check_surroundings(@b_bishop, move_list)
        expect(move_list.values.reduce([], :concat).length).to eq(11)
      end
    end

    context "b_knight at d5 [4,4], b_rook at c3 [6,3]" do
      before {@b_knight = Knight.new(:black, [4,4])}
      before {@b_rook = Rook.new(:black, [6,3])}
      it "should return a list with 7 moves" do
        @board_class.board[5][4] = @b_knight
        @board_class.board[6][3] = @b_rook
        move_list = @b_knight.get_moves
        @board_class.check_surroundings(@b_knight, move_list)
        expect(move_list.length).to eq(7)
      end
    end
  end

  describe "#move_piece" do
    context "b_king is moving from e8 [1,5] to f7 [2,6]" do
      before {@b_king = King.new(:black, [1,5])}
      it "should have the king in f7 [2,6]" do
        @board_class.board[1][5] = @b_king
        @board_class.move_piece([1,5], [2,6])
        expect(@board_class.board[2][6]).to eq(@b_king)
      end

      it "should update the king's current position to [2,6]" do
        @board_class.board[1][5] = @b_king
        @board_class.move_piece([1,5], [2,6])
        expect(@b_king.current_pos).to eq([2,6])
      end

      it "should set the has_moved flag to true" do
        @board_class.board[1][5] = @b_king
        @board_class.move_piece([1,5], [2,6])
        expect(@b_king.has_moved).to be true
      end
    end

    context "b_pawn moves from h7 [2,8] to h6 [3,8]" do
      before {@b_pawn = Pawn.new(:black, [2,8])}

      it "should have the pawn in h6 [3,8]" do
        @board_class.board[2][8] = @b_pawn
        @board_class.move_piece([2,8], [3,8])
        expect(@board_class.board[3][8]).to eq(@b_pawn)
      end

      it "should update the pawn's current position to [3,8]" do
        @board_class.board[2][8] = @b_pawn
        @board_class.move_piece([2,8], [3,8])
        expect(@b_pawn.current_pos).to eq([3,8])
      end

      it "should set the has_moved flag to true" do
        @board_class.board[2][8] = @b_pawn
        @board_class.move_piece([2,8], [3,8])
        expect(@b_pawn.has_moved).to be true
      end

      it "should remove the 2 step move from the move hash" do
        @board_class.board[2][8] = @b_pawn
        @board_class.move_piece([2,8], [3,8])
        expect(@b_pawn.moves.key?(:two_squares)).to be false
      end
    end

    context "w_pawn g2 [7,7] moves 2 spaces" do
      before {@w_pawn = Pawn.new(:white, [7,7])}
      it "should move to g4 [5,7]" do
        @board_class.board[7][7] = @w_pawn
        next_move = @w_pawn.get_moves()[:two_squares][0]
        @board_class.move_piece([7,7], next_move)
        expect(@board_class.board[5][7]).to eq(@w_pawn)
      end
    end
  end
end