require 'card.rb'
require 'hand.rb'

class Deck
  attr_accessor :deck
  
  def initialize
    @deck = create_deck
  end
  
  def create_deck
    cards = []
    (2..14).each do |number|
      ['s','c','h','d'].each do |suit|
        cards << Card.new(suit, number)
      end
    end
    cards.shuffle
  end
  
  def deal_hand
    Hand.new(@deck.pop(5))
  end
end