module Saving
  def save_game
    print "Saving... "
    write_to_save_file(save_data)
    sleep(0.5)
    print "Saved!\n"
  end

  def write_to_save_file(data)
    filename = "hangman_save_#{Time.now.strftime('%m%d%y_%H%M')}.yaml"
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open("saves/#{filename}", "w") { |file| file.write(data)}
  end

  def load_save_file(save_files, input)
    data = YAML.load(File.read("saves/#{save_files[input]}"))
    @codeword = data[:codeword]
    @blanks = data[:blanks]
    @guesses_left = data[:guesses_left]
    @player_guesses = data[:player_guesses]
  end

  def load_game(input = nil)
    save_files = Dir.children('saves')
    puts load_screen(saves_string(save_files))
    loop do 
      input = get_input(:load)
      return if input == 'exit'
      break if valid_input?(input, save_files)
      print "\e[1A\e[29D\e[K"
    end
    p input
    load_save_file(save_files, input.to_i)
  end

  def saves_string(save_files)
    string = ""
    save_files.each_with_index do |file_name, index|
      string += "    [#{index}] #{file_name}\n"
    end
    string
  end

  def valid_input?(input, save_files)
    if input.to_i.to_s == input && input.to_i.between?(0, save_files.length - 1)
      true
    else
      print game_error(:invalid_input)
    end
  end
end