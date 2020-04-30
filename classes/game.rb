require_relative "../modules/text_content"
require_relative "player"

class Game
  include TextContent
  @@dictionary = File.readlines("lib/5desk.txt").keep_if { |word| word.length.between?(5, 12) }

  def play
    playing = true
    puts welcome
    continue
    while playing
      @player = Player.new
      @guesses_left = 7
      select_word
      while @guesses_left != 0
        play_round
        break if player_wins?
      end
      playing = play_again?
    end
  end

  def select_word
    index = Random.new.rand(@@dictionary.length)
    @codeword = @@dictionary[index].chomp.downcase
    @blanks = @codeword.split('').map { |word| '_' }.join
  end

  def play_round
    puts round_display
    puts "DEBUG: codeword: #{@codeword}"
    print_past_guesses
    get_guess
    check_guess(@player.guess)
  end

  def get_guess
    loop do
      print game_message(:guess)
      @player.guess_code
      break if valid_guess?(@player.guess, @player.guesses)
      print "\e[1A\e[29D\e[K"
    end
    @player.guesses << @player.guess
  end

  def check_guess(guess)
    if @codeword.include?(guess)
      @codeword.split('').each_with_index do |letter, index|
        if letter == guess
          @blanks[index] = guess
        end
      end
    else
      @guesses_left -= 1
    end
  end

  def print_past_guesses
    print "Past guesses: "
    @player.guesses.each { |guess| print "#{guess} " }
    print "\n"
  end

  def player_wins?
    if @blanks == @codeword
      puts round_display
      puts game_result(:win)
      true
    elsif @guesses_left == 0
      puts game_result(:lose)
    end
  end

  def valid_guess?(guess, guesses)
    if guess.nil? || guess.length != 1 || !guess.match?(/[a-z]/)
      print game_error(:invalid_guess)
    elsif guesses.include?(guess)
      print game_error(:existing_guess)
    else
      return true
    end
    false
  end

  def play_again?
    input = ""
    until ['y', 'n'].include?(input)
      print game_message(:play_again)
      input = gets.chomp.downcase
      print "\e[1A\e[K"
    end
    input == 'y' ? true : false
  end
end