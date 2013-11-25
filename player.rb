class Player
  attr_accessor :hand, :name
  
  def initialize(name)
    @hand = nil
    @name = name
  end
  
  def choose_cards_to_remove
    puts "\n"
    p @hand
    puts "#{@name}, please enter the indices (1 through 5) of the cards to discard. (Example: 1,3,4)"
    cards_to_remove = gets.chomp.split(',').map! { |num| num.to_i - 1 }
  end
end