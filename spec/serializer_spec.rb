require_relative '../lib/serializer.rb'
require_relative '../lib/chess.rb'
require 'json'
require 'pp'

RSpec.describe Serializer do
  before do 
    @chess_game = Chess.new
    @chess_game.generate_pieces
    @game_saver = described_class.new
  end

  describe "#save_game" do
    context "saving new game file" do
      it "it should add a new file in the save_files folder" do
        expect{@game_saver.save_game(@chess_game)}.to output(include('created successfully.')).to_stdout
      end
    end
  end
end