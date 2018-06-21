class Code
  PEGS = {red: "r", orange: "o", yellow: "y", green: "g", blue: "b", purple: "p"}

  attr_reader :pegs, :guess

  def initialize(arr)
    @pegs = arr
  end

  def [](argument)
    pegs[argument]
  end

  def to_a
    result = []
    i = 0
    while i < 4
      result << self[i]
      i += 1
    end
    result
  end

  def ==(argument)
    return false if argument.class != Code
    return true if self.to_a == argument.to_a
    false
  end

  def self.random
    result = PEGS.values.shuffle
    2.times {|el| result.pop}
    Code.new(result)
  end

  def self.parse(input)
    array = input.split("")
    if array.any? {|char| !PEGS.has_value?(char)}
      raise "Please select an actual color!"
    else
      Code.new(array)
    end
  end

  def exact_matches(guess)
    result = 0
    i = 0
    while i < 4
      result += 1 if self[i] == guess[i]
      i += 1
    end

    result
  end

  def near_matches(guess)
    result = 0
    temp = []
    i = 0
    while i < 4
      if self[i] != guess[i] && self.my_include?(guess[i]) && !temp.include?(guess[i])
        result += 1
        temp << guess[i]
        i += 1
      else
        i += 1
      end
    end
    result
  end

  def my_include?(el)
    i = 0
    while i < 4
      return true if self[i] == el
      i += 1
    end
    false
  end


end

class MastermindGame
  attr_reader :secret_code, :guess, :bot, :user

  def initialize(bot, user, code = Code.random)
    if code.class == Code
      @secret_code = code
    else
      @secret_code = Code.new(code)
    end
    @bot = bot
    @user = user
  end

  def play
    number_of_guesses = 1
    bot.send_message(453279275009835022, "Welcome to Mastermind! The object of this game is to guess the four
    colors that the computer has randomally selected. You can choose from
    these colors: \"r, g, y, p, b, o\" \(ex: rypb\). A \"near\" guess is a guess
    where a color is correct, but it is not in the exact position. An
    \"exact\" guess is a guess that is a correct color in the correct position.")
    sleep 10.0
    get_guess
    sleep 5.0
    until won?
      display_matches(guess)
      get_guess
      sleep 5.0
      number_of_guesses += 1
    end

    if number_of_guesses == 1
      bot.send_message(453279275009835022, "WOW! You guess correctly on your first try! #{secret_code.to_a}")
    else
      bot.send_message(453279275009835022, "Congratulations! It was #{secret_code.to_a}, and it only took you
      #{number_of_guesses} times to guess it!")
    end

  end

  def get_guess
    @guess = ""
    bot.send_message(453279275009835022, "What is your guess?")
    bot.send_message(453279275009835022, "You can choose from **\"r, g, y, p, b, o\"** (ex: rybg)")
    user.await(:guess) do |get_guess|
    @guess = get_guess.message.content.downcase
    end
    sleep 6.0
    @guess = Code.parse(@guess)
  end

  def display_matches(guess)
    bot.send_message(453279275009835022, "exact: #{secret_code.exact_matches(guess)}")
    bot.send_message(453279275009835022, "near: #{secret_code.near_matches(guess)}")
  end

  def won?
    secret_code.exact_matches(guess) == 4
  end
end
