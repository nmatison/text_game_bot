class Ships
  attr_reader :ship

  def initialize(ship)
    ship.downcase!
    if ship == "ac"
      ship_setup(5)
    elsif ship == "b"
      ship_setup(4)
    elsif ship == "s"
      ship_setup(3)
    elsif ship == "d"
      ship_setup(3)
    elsif ship == "pb"
      ship_setup(2)
    end
  end

  def ship_setup(num)
    @ship = Array.new(10)
    ship_idxs = (0..9).to_a.shuffle[0...num]
    @ships.each_with_index do |num, idx|
      ship_idxs.each do |num2|
        @ships[idx] = :s   if num2 == idx
      end
    end
    @ship
  end
end
