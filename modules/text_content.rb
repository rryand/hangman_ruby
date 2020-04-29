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

  def round_display(turn, blanks)
    clear_screen
    <<~HEREDOC
    #{WELCOME_TEXT}

    #{blanks.center(50)}

    Guesses left: #{-turn + 8}
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
      guess: "Enter your guess: "
    }[message]
  end

  def game_error(error)
    print "ERROR: "
    {
      invalid_guess: "Please enter a letter."
    }[error]
  end
end