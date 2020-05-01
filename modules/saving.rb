module Saving
  def save_game
    puts "Saving..."
    write_to_save_file(save_data)
    puts "Saved!"
    continue
  end

  def write_to_save_file(data)
    filename = "hangman_save_#{Time.now.strftime('%m%d%y_%H%M')}.yaml"
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open("saves/#{filename}", "w") { |file| file.write(data)}
  end

  def load_game(input = nil)
    puts load_screen(saves_string)
    loop do 
      input = get_input(:load)
      return if input == 'exit'
      break if input.to_i.to_s == input
      print "\e[1A\e[29D\e[K"
    end
    p input
    continue
  end

  def saves_string
    string = ""
    Dir.children("saves").each_with_index do |file_name, index|
      string += "    [#{index}] #{file_name}\n"
    end
    string
  end
end