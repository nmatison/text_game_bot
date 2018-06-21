require 'discordrb'
require_relative 'hangman/hangman'
require_relative 'battleship/battleship'
require_relative 'mastermind/mastermind'


bot = Discordrb::Commands::CommandBot.new token: 'NDUzMjc4Njk5NDEzMDQ1MjQ4.Dfc_Xg.qOxNXKcpXTpq08OArF3D5eIVzpw',
client_id: 453278699413045248, prefix: '!'


bot.command :random do |event, min, max|
  rand(min.to_i .. max.to_i)
end

bot.command :ping do |event|
  event.respond 'Pong!'
end

bot.command :mastermind do |event|
  MastermindGame.new(bot, event.user).play
end
# bot.command :battleship do |event|
#   event.respond "Who will play with event.user? Say !here"
#   sleep 6.0
#   bot.command :here do |event2|
#
#     Hangman.new(bot, event, {guesser: HumanPlayer.new(event.user), referee: HumanPlayer.new(event2.user)})
#   end
# end

bot.command :hangman do |event|
  Hangman.new(bot, event, {guesser: ComputerPlayer.new(bot.name), referee: HumanPlayer.new(event.user)}).play
end

bot.run
