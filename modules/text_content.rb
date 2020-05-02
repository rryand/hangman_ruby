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
    Type: 'save' - save and exit
          'load' - load a saved game
          'exit' - exit game

    #{@blanks.center(50)}

    Guesses left: #{@guesses_left}
    HEREDOC
  end

  def load_screen(delete_mode, string)
    modes = ["delete", "load"]
    title = delete_mode ? "delete" : "load"
    clear_screen
    <<~HEREDOC
    #{LINE}
    #{"#{title.upcase} GAME".center(50)}
    #{LINE}
    Type: 'load' - load a game 
          'delete' - delete a game
          'exit' - exit screen

    Enter the number of the file you would like to
    #{title}. 

    #{string}
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
      play_again: "Play again?(y/n) ",
      goodbye: "Thank you for playing hangman! Goodbye!",
      load: "Input: "
    }[message]
  end

  def game_result(result)
    message = {
      win: "You win! You saved the hangman!",
      lose: "You lose. Better luck next time!",
      reveal: "The word was '#{@codeword}'."
    }[result]
    "#{LINE}\n#{message.center(50)}\n#{LINE}"
  end

  def game_error(error)
    message = {
      invalid_guess: "Please enter a letter.",
      existing_guess: "Guess already exists.",
      invalid_input: "Invalid input."
    }[error]
    print "\e[K\e[41mERROR: #{message}\e[0m"
  end
end