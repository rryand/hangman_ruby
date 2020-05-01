require_relative "../modules/text_content"
require_relative "../modules/saving"
require_relative "player"

class Game
  include TextContent, Saving
  @@dictionary = File.readlines("lib/5desk.txt").keep_if { |word| word.length.between?(5, 12) }

  def initialize
    puts welcome
    continue
    @player = Player.new
  end
  
  public

  def play(playing = true)
    while playing && !@saving
      @player.guesses.clear
      @guesses_left = 7
      select_word
      while @guesses_left != 0
        play_round
        break if player_wins? || @saving
      end
      playing = play_again? unless @saving
    end
    puts game_message(:goodbye)
  end

  private

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

  def save_data
    save_hash = {
      codeword: @codeword,
      blanks: @blanks,
      guesses_left: @guesses_left,
      player_guesses: @player.guesses
    }
    YAML.dump(save_hash)
  end

  def get_input(message)
    print game_message(message)
    gets.chomp.downcase
  end

  def get_guess
    loop do
      @player.guess = get_input(:guess)
      break if valid_guess?(@player.guess, @player.guesses)
      print "\e[1A\e[29D\e[K"
    end
    @player.guesses << @player.guess unless ["save", "load"].include?(@player.guess)
  end

  def check_guess(guess)
    if guess == "save"
      @saving = true
      save_game
    elsif guess == "load"
      load_game
    elsif @codeword.include?(guess)
      insert_letter(guess)
    else
      @guesses_left -= 1
    end
  end

  def insert_letter(guess)
    @codeword.split('').each_with_index do |letter, index|
      if letter == guess
        @blanks[index] = guess
      end
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
    return true if guess == "save" || guess == "load"
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