require_relative 'hangman'
require 'discordrb'

class HumanPlayer
attr_reader :user, :secret_length, :guesses, :letter, :length, :spots, :answer

  def initialize(user)
    @user = user
    @guesses = []
    @letter = nil
  end

  def guess(bot, board)
      bot.send_message(453279275009835022, "Please guess a letter. \(ex: a\)")

      user.await(:guess) do |guess_event|
        guess = guess_event.message.content
        @letter = guess
      end

      sleep 5.0
      @letter
    end

  def pick_secret_word(bot)
    bot.send_message(453279275009835022, "Please input the LENGTH of your word. (Not the word itself!)")
    user.await(:length) do |length_event|
      @length = length_event.message.content.to_i
    end
    sleep 5.0
    @length
  end

  def check_guess(letter, bot)
    bot.send_message(453279275009835022, "Does #{letter} appear in your word? #{user.name} (yes or no)")
    user.await(:answer) do |get_answer|
      @answer = get_answer.message.content
    end
    sleep 5.0
    @answer

    if @answer == "yes"
      bot.send_message(453279275009835022, "In which spot(s) does the letter appear (1, 2, 5, etc)")
      user.await(:spots) do |get_spots|
        @spots = get_spots.message.content
      end
      sleep 5.0
    else
      return []
    end
    @spots.split(", ").map!{|el| (el.to_i - 1)}
  end

  def register_secret_length(length)
    @secret_length = length
  end

  def handle_response(letter, bot, board, array = [])
    guesses << letter
    bot.send_message(453279275009835022, "#{user.name}'s guesses so far: #{guesses}")
  end

  def secret_word
    @secret_word = ""
  end
end



class ComputerPlayer
  attr_reader :dictionary, :secret_word, :name, :secret_length, :guesses, :letter

  def initialize(name = "Robo", wordz = File.readlines("hangman/dictionary.txt").shuffle)
    @dictionary = []
    wordz.each {|word| dictionary << word.chomp}
    @name = name
    @guesses = []
  end

  def guess(bot, board)
    alphabet = ("a".."z").to_a
    hash = {}
#creates the hash
    alphabet.each do |letter|
      hash[letter] = 0
    end
#gets each letter count
    dictionary.each do |word|
      word.chars.each do |letter|
        hash[letter] += 1
      end
    end

    sorted_hash = hash.sort_by {|k, v| v}.reverse
    letter = sorted_hash[0][0]
    i = 0
    until !board.include?(letter) && !guesses.include?(letter)
      letter = sorted_hash[i][0]
      i += 1
    end
    @letter = letter

  end

  def handle_response(letter, bot, board, arr = [])
    guesses << letter
    bot.send_message(453279275009835022, "#{name}'s guesses so far: #{guesses}")
    if arr.length == 0
      dictionary.select!{|word| !word.include?(letter)}
    else
      temp_dic = @dictionary
      @dictionary = []

      temp_dic.each do |word|
        i = 0
        temp_arr = []
        while i < word.length
          temp_arr << i if word[i] == letter
          i += 1
        end
        @dictionary << word if temp_arr == arr
      end

    end

  end

  def register_secret_length(length)
    @secret_length = length
    temp_dic = @dictionary
    @dictionary.select! {|word| word.length == secret_length}
  end

  def candidate_words

  dictionary
  end

  def pick_secret_word(bot)
    @secret_word = dictionary[0]
    secret_word.length
  end

  def check_guess(letter, bot)
    result = []

    secret_word.chars.each.with_index do |el, idx|
      result << idx if el == letter
    end

    result
  end
end
