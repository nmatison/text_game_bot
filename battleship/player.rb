class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_play(grid)
    puts "#{name}, where would you like to attack? (ex: 1, 1)"
    play = gets.chomp.split(", ").map{|el| el.to_i}
  end

end
