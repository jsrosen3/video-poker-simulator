class Card
  attr_reader :suit, :number
  
  def initialize(suit, number)
    @suit = suit
    @number = number
  end
  
  def inspect
    suits = {"s" => "\u2660", "c" => "\u2663", "h" => "\u2665", "d" => "\u2666"}
    numbers = {11 => 'J', 12 => 'Q', 13 => 'K', 14 => 'A'}
    (2..10).each { |x| numbers[x] = x.to_s }
    numbers[@number] + suits[@suit]
  end
end