module TextContent
  LINE = '-' * 50
  WELCOME_TEXT = "#{LINE}\n#{"Welcome to \e[1;5mHANGMAN!\e[0m".center(60)}\n#{LINE}"

  def welcome
    clear_screen
    <<~HEREDOC
    #{WELCOME_TEXT}

    Your job is to guess the word within 7 turns or 
    else the hangman gets it!

    HEREDOC
  end

  def round_display
    clear_screen
    <<~HEREDOC
    #{WELCOME_TEXT}

    #{@blanks.center(50)}

    Guesses left: #{@guesses_left}
    HEREDOC
  end

  def continue
    print "Press enter to continue..."
    gets
    print "\e[1A\r"
  end

  def clear_screen
    print `clear`
  end

  def game_message(message)
    {
      guess: "Enter your guess: ",
      play_again: "Play again?(y/n) "
    }[message]
  end

  def game_result(result)
    message = {
      win: "You win! You saved the hangman!",
      lose: "You lose. Better luck next time!"
    }[result]
    "#{LINE}\n#{message.center(50)}\n#{LINE}"
  end

  def game_error(error)
    message = {
      invalid_guess: "Please enter a letter.",
      existing_guess: "Guess already exists."
    }[error]
    print "\e[K\e[41mERROR: #{message}\e[0m"
  end
end