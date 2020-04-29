require_relative "../modules/text_content"

class Game
  include TextContent
  @@dictionary = File.readlines("lib/5desk.txt").keep_if { |word| word.length.between?(5, 12) }

  def play
    puts welcome
    continue
    select_word
    for turn in 1..7
      play_round(turn)
    end
  end

  def select_word
    index = Random.new.rand(@@dictionary.length)
    @codeword = @@dictionary[index].chomp
    @blanks = @codeword.split('').map { |word| '_' }.join
  end

  def play_round(turn)
    puts round_display(turn, @blanks)
    puts "DEBUG: codeword: #{@codeword}"
    loop do
      print game_message(:guess)
      guess = gets.chomp.downcase
      break if valid_guess?(guess)
      print "\e[1A\e[29D\e[K"
    end
  end

  def valid_guess?(guess)
    if guess.nil? || guess.length != 1 || !guess.match?(/[a-z]/)
      print game_error(:invalid_guess)
      false
    else
      true
    end
  end
end