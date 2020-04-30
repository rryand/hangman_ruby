class Player
  attr_accessor :guess, :guesses

  def initialize
    @guesses = []
  end

  def guess_code
    @guess = gets.chomp.downcase
  end
end