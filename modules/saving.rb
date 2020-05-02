module Saving
  DELAY = 0.6
  
  def save_game
    print "Saving... "
    write_to_save_file(save_data)
    sleep(DELAY)
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
    @player.guesses = data[:player_guesses]
  end

  def load_game(input = nil, delete = false)
    print load_screen(delete, saves_string(Dir.children('saves')))
    loop do
      save_files = Dir.children('saves')
      input = get_input(:load)
      return if input == 'exit'
      if input == 'delete'
        delete = true
        print_delete_screen(saves_string(save_files))
      elsif input == 'load'
        delete = false 
        print load_screen(delete, saves_string(save_files))
      end
      if valid_input?(input, save_files)
        if delete
          delete_game(input.to_i, save_files) 
        else
          load_save_file(save_files, input.to_i)
          break
        end
      end
    end
  end

  def delete_game(input, save_files)
    print "Deleting #{save_files[input]}"
    sleep(DELAY)
    3.times do
      print '.' 
      sleep(DELAY)
    end
    File.delete("saves/#{save_files[input]}")
    print load_screen(true, saves_string(Dir.children('saves')))
  end

  def print_delete_screen(string)
    print load_screen(true, string)
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
    elsif !['load', 'delete'].include?(input)
      print game_error(:invalid_input)
      print "\e[1A\e[29D\e[K"
    end
  end
end