require "discordrb"
require_relative 'players'

class Hangman
  attr_reader :guesser, :referee, :board, :bot, :event, :num_of_guesses

  def initialize(bot, event, player)
    @guesser = player[:guesser]
    @referee = player[:referee]
    @bot = bot
    @event = event
    @num_of_guesses = 0
  end

  def setup
    word_length = referee.pick_secret_word(bot)
    sleep 5.0 if referee.class == HumanPlayer
    guesser.register_secret_length(word_length)
    @board = ""
    (word_length).times do |el|
      board << "+"
    end
    @num_of_guesses = word_length + 4
  end

  def play
    bot.send_message(453279275009835022, 'Welcome to Hangman! The object is to guess the correct word before you run out
       of guesses! As of right now you can only guess letters and not words, and you have 7 seconds for each guess.')
    sleep 5.0
    setup
    counter = 0
    until !board.include?("+") || counter == num_of_guesses
      bot.send_message(453279275009835022, "#{guesser.name} has \# #{num_of_guesses - counter} attempts left, and #{board.count("+")} letters left.")
      take_turn
      counter += 1
    end
    conclusion(board, counter)
  end

  def conclusion(board, counter)
    if counter == num_of_guesses && board.include?("+") && guesser.class == HumanPlayer
      bot.send_message(453279275009835022, "Oh no! #{guesser.name} took too many guesses! The word was \"#{referee.secret_word}\"")
    elsif counter == num_of_guesses && board.include?("+")
      if guesser.class == HumanPlayer
        bot.send_message(453279275009835022, "Oh no! #{guesser.name} took too many guesses!")
      else
        bot.send_message(453279275009835022, "Oh no! Text Game Bot took too many guesses!")
      end
    else
      if guesser.class == HumanPlayer
       bot.send_message(453279275009835022, "Congratulations #{guesser.name}! You guessed \"#{board}\" in #{counter} attempts!")
     else
       bot.send_message(453279275009835022, "I guessed #{referee.name}\'s word \"#{board}\" in #{counter} attempts! Impressed? :smirk:")
     end
    end
  end

  def take_turn
      guesser.guess(bot, board)
      sleep 7.0 if guesser.class == HumanPlayer
      sleep 2.0 if guesser.class == ComputerPlayer
      @letter = guesser.letter
      until @letter.length == 1
        bot.send_message(453279275009835022, "Your guess must be a single letter!")
        guesser.guess(bot, board)
        @letter = guesser.letter
        sleep 7.0
      end

      indexes = referee.check_guess(@letter, bot)
      sleep 7.0 if referee.class == HumanPlayer
      update_board(@letter, indexes)
      guesser.handle_response(@letter, bot, board, indexes)
      bot.send_message(453279275009835022, board)
  end

  def update_board(letter, indexes)
    indexes.each do |num|
      board[num] = letter
    end

  end
end
