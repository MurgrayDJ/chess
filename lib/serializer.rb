require 'json'
require 'pp'

class Serializer
  @@game_info = Hash.new {|h,k| h[k] = Hash.new(&h.default_proc)}

  def initialize
    Dir.mkdir('../savefiles') unless Dir.exist?('../savefiles')
  end

  def save_game(game_obj)
    @@game_info = game_obj.to_deep_hash
    date_and_time = Time.new.strftime("%Y-%m-%d_%H%M%S")
    file_name = "chess_#{date_and_time}.txt"
    file_location = "savefiles/#{file_name}"

    File.open(file_location, 'w') do |file|
      file.puts @@game_info.to_json
    end

    puts "#{file_name} created successfully."
    file_name
  end

  def load_save(chess_obj)
    chess_obj.round = @@game_info[:round]
    load_player(chess_obj, "player1")
    load_player(chess_obj, "player2")
    set_current_player(chess_obj)
    load_board(chess_obj)
  end

  def set_current_player(chess_obj)
    if @@game_info[:current_player]["color"] == "white"
      chess_obj.current_player = chess_obj.player1
    else
      chess_obj.current_player = chess_obj.player2
    end
  end

  def load_board(chess_obj)
    chess_board = chess_obj.instance_variable_get("@board")
    board_var = @@game_info[:board]
    @@game_info[:board]["board"].each_with_index do |row, x|
      row.each_with_index do |slot, y|
        if slot.is_a?(Hash)
          chess_board.board[x][y] = build_piece(slot)
        end
      end
    end
    chess_board.captured_pieces[:white] = @@game_info[:board]["captured_pieces"]["white"]
    chess_board.captured_pieces[:black] = @@game_info[:board]["captured_pieces"]["black"]
  end

  def build_piece(slot)
    piece = Object.const_get(slot["type"].capitalize)
    piece = piece.new(slot["color"].to_sym, slot["start_pos"])
    piece.current_pos = slot["current_pos"]
    piece
  end

  def load_player(chess_obj, player)
    player_var = chess_obj.instance_variable_get("@#{player}")
    @@game_info["#{player}".to_sym].each do |key, val|
      if key == "color" then val = val.to_sym end
      player_var.instance_variable_set("@#{key}", val)
    end
  end

  def open_save(file_path, chess_obj)
    if File.exist?(file_path)
      save_contents = File.read(file_path)
      @@game_info = JSON.parse save_contents.gsub('=>', ':')
      @@game_info.transform_keys!(&:to_sym)
      File.delete(file_path)
      load_save(chess_obj)
    else
      puts "Issue opening file. Please try a different one."
    end
  end

  def find_save(chess_obj)
    save_files = Dir.children("savefiles/")
    save_files.unshift("blank")
    save_files.each_with_index do |save_file, file_number|
      if file_number != 0
        puts "#{file_number}. #{save_file}"
      end
    end
    puts
    save_prompt = "Please pick a save file number: "
    valid_save_nums = Array (1..save_files.length-1).map {|a| a.to_s}
    save_num = get_valid_data(save_prompt, nil, valid_save_nums).to_i
    puts "Save file chosen: #{save_num}. #{save_files[save_num]}"
    puts
    open_save("savefiles/#{save_files[save_num]}", chess_obj)
  end

  def get_valid_data(prompt, response, valid_responses) 
    if response.nil?
      print prompt
      response = gets.chomp
    else
      valid_responses.each do |valid_response|
        if response.casecmp?(valid_response)
          return response
        elsif response.casecmp?("EXIT") || response.casecmp?("QUIT")
          puts "Thank you for playing!"
          exit!
        elsif response.casecmp?("HELP")
          print_rules
          break
        end
      end
      response = nil
    end
    response = get_valid_data(prompt, response, valid_responses)  
  end
end