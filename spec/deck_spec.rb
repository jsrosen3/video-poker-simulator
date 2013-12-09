require 'rspec'
require 'deck.rb'

describe "Deck" do 

  subject(:deck) { Deck.new }

  describe "#initialize" do
    it "creates a deck with exactly 52 cards" do
      expect(deck.deck.length).to eq(52)
    end

    it "creates a deck with all unique cards" do
      expect(deck.deck.uniq.length).to eq(52)
    end
  end

  describe "#deal_hand" do

    subject(:hand) { Deck.new.deal_hand }

    it "deals a hand with exactly 5 cards" do
      expect(hand.hand.length).to eq(5)
    end

    it "deals a hand with all unique cards" do
      expect(hand.hand.uniq.length).to eq(5)
    end
  end
end