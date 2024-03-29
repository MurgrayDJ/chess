require_relative '../lib/serializer.rb'
require_relative '../lib/chess.rb'

RSpec.describe Serializer do
  before do 
    @chess_game = Chess.new
    @game_saver = described_class.new
  end

  # describe "#save_game" do
  #   context "" do

  #   end
  # end
end