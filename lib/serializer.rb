

def open_save(file_path)
  if File.exist? file_path
    save_contents = File.read(file_path)
    @@game_info = JSON.parse save_contents.gsub('=>', ':')
    @@game_info.transform_keys!(&:to_sym)
    File.delete(file_path)
    play_game
  else
    puts "Issue opening file. Please try a different one."
  end
end

def find_save
  save_files = Dir.children("./savefiles")
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
  open_save("./savefiles/#{save_files[save_num]}")
end

def saved_or_new_game(choice)
  puts
  if choice == "1"
    new_game
  else
    find_save
  end
end

def save_game
  Dir.mkdir('savefiles') unless Dir.exist?('savefiles')
  date_and_time = Time.new.strftime("%Y-%m-%d_%H%M%S")
  filename = "savefiles/hangman_#{date_and_time}.txt"

  File.open(filename, 'w') do |file|
    file.puts @@game_info.to_json
  end

  puts "#{filename} created succesfully."
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