require_relative 'board'
require_relative 'player'
require_relative 'ComputerPlayer'
require_relative 'ships'

=begin Here is my updated battle ship game. It works as its own game (sort of)
I got all of the *bonus* objectives listed on the curriculum finished execept
for the different ships (the last bullet point). I have many ideas on how to
do it, but it won't really work the way I want it to with the way the specs are
set up. This should be able to function as a game and pass all the specs. Please
review this one and not the original battleshipgame file I uploaded if possible.
=end

class BattleshipGame
  attr_reader :board, :player, :toggle, :player2, :board2
  def initialize(bot)
    @player = name
    @board = board
    @player2 = name2
    @board2 = board2
    @toggle = true
  end

  def attack(position)
    if toggle
      board.grid[position[0]][position[1]] = :x
    else
      board2.grid[position[0]][position[1]] = :x
    end
  end

  def count
    if toggle
      board.count
    else
      board2.count
    end
  end

  def game_over?
    board.won?
  end

  def setup
    puts "How many ships would you like to place for each player?"
    num_of_ships = gets.chomp.to_i

    counter = 1
    until counter == num_of_ships + 1
      puts "#{player.name} please place ship \##{counter}. (ex 1, 0)"
      position = gets.chomp.split(", ").map{|el| el.to_i}
      board2.grid[position[0]][position[1]] = :s
      counter += 1
    end

    switch_player

    counter = 1
    until counter == num_of_ships + 1
      puts "#{player2.name} please place ship \##{counter}. (ex 1, 0)"
      position = gets.chomp.split(", ").map{|el| el.to_i}
      board.grid[position[0]][position[1]] = :s
      counter += 1
    end

    switch_player
  end

  def play
    setup
    until board.won? || board2.won?
      play_turn
    end
    switch_player
    puts "Congrats! #{current_player.name} won!"
  end

  def play_turn
    position = current_player.get_play(board.grid)
    attack(position)
    #uncomment below to have each player's board labeled. Needs to be commented
    #to pass the specs.
    #p "#{current_player.name}\'s board"
    if toggle
      p board.grid
    else
      p board2.grid
    end
    switch_player
  end

  def current_player
    return player if toggle
    player2
  end

  def switch_player
    @toggle = !@toggle
  end

end


if __FILE__ == $PROGRAM_NAME
  BattleshipGame.new(HumanPlayer.new("Nick"), Board.new, HumanPlayer.new("Boo"), Board.new).play
end
