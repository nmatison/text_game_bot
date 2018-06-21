class Board
attr_reader :grid

  def initialize(grid = Board.default_grid)
    @grid = grid
  end

  def self.default_grid
    Array.new(10) {Array.new(10) {nil}}
  end

  def place_random_ship
    raise "error" if full?
    row = (0..grid.length - 1).to_a.sample
    spot = (0..grid[0].length - 1).to_a.sample
    grid[row][spot] = :s
  end

  def count
    total = 0
    grid.each {|row| total += row.count(:s)}
    total
  end

  def empty?(position = grid)
    if position != grid
      return true if grid[position[0]][position[1]] == nil
      return false
    else
      grid.none? {|row| row.include?(:s) || row.include?(:x)}
    end
  end

  def full?
    return true if count == grid.length * grid[0].length
    false
  end

  def won?
    grid.none? {|row| row.include?(:s)}
  end

  def [](array)
    grid[array[0]][array[1]]
  end
end
