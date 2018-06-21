class ComputerPlayer
  attr_reader :name, :attacks

  def initialize(name = "Robo")
    @name = name
    @attacks = []
  end

  def get_play(grid)
    row = (0..grid.length - 1).to_a.sample
    spot = (0..grid[0].length - 1).to_a.sample
    play = [row, spot]
    until !attacks.include?(play)
      row = (0..grid.length - 1).to_a.sample
      spot = (0..grid[0].length - 1).to_a.sample
      play = [row, spot]
    end
    attacks << play
    play
  end

end
