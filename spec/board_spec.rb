require_relative '../lib/board.rb'

RSpec.describe Board do
  before { @board_class = described_class.new }

  describe "#print_board" do
    context 'board is empty' do 
      it 'should print an empty board' do
        @board_class.print_board
      end
    end
  end
end