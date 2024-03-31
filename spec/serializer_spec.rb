require_relative '../lib/serializer.rb'
require_relative '../lib/chess.rb'
require 'json'
require 'pp'

RSpec.describe Serializer do
  before do 
    @chess_game = Chess.new
    @chess_game.generate_pieces
    @game_saver = described_class.new
    @new_files = []
  end
  SAVE_DIR = "savefiles/"

  after do
    @new_files.each do |filename|
      file = "#{SAVE_DIR}#{filename}"
      File.delete(file)
    end
  end

  describe "#save_game" do
    context "saving new game file" do 
      it "should create a new save file" do
        file_name = @game_saver.save_game(@chess_game)
        @new_files << file_name
        expect(File.file?("#{SAVE_DIR}#{file_name}"))
      end
    end
  end
end