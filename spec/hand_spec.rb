require 'rspec'
require 'hand.rb'
require 'card.rb'

describe "Hand" do 

  describe "#score" do

    ace_of_s = Card.new('s', 14)
    king_of_s = Card.new('s', 13)
    queen_of_s = Card.new('s', 12)
    jack_of_s = Card.new('s', 11)
    ten_of_s = Card.new('s', 10)
    nine_of_s = Card.new('s', 9)
    two_of_s = Card.new('s', 2)
    three_of_s = Card.new('s', 3)
    four_of_s = Card.new('s', 4)
    five_of_s = Card.new('s', 5)
    six_of_s = Card.new('s', 6)
    four_of_h = Card.new('h', 4)
    four_of_c = Card.new('c', 4)
    four_of_d = Card.new('d', 4)
    queen_of_d = Card.new('d', 12)

    context "when the hand is a royal flush" do
      it "scores 250" do 
        hand = Hand.new([ace_of_s, king_of_s, queen_of_s, jack_of_s, ten_of_s].shuffle)
        expect(hand.score).to eq(250)
      end
    end

    context "when the hand is a straight flush" do
      it "scores 50" do 
        hand = Hand.new([nine_of_s, king_of_s, queen_of_s, jack_of_s, ten_of_s].shuffle)
        expect(hand.score).to eq(50)

        hand = Hand.new([ace_of_s, two_of_s, three_of_s, four_of_s, five_of_s].shuffle)
        expect(hand.score).to eq(50)
      end
    end

    context "when the hand is four of a kind" do
      it "scores 25" do
        hand = Hand.new([four_of_d, four_of_h, four_of_c, four_of_s, ten_of_s].shuffle)
        expect(hand.score).to eq(25)
      end
    end

    context "when the hand is a full house" do
      it "scores 9" do  
        hand = Hand.new([four_of_d, four_of_h, four_of_c, queen_of_d, queen_of_s].shuffle)
        expect(hand.score).to eq(9)
      end
    end

    context "when the hand is a flush" do
      it "scores 6" do
        hand = Hand.new([ace_of_s, two_of_s, four_of_s, jack_of_s, ten_of_s].shuffle)
        expect(hand.score).to eq(6)
      end
    end

    context "when the hand is a straight" do
      it "scores 4" do
        hand = Hand.new([ace_of_s, king_of_s, queen_of_d, jack_of_s, ten_of_s].shuffle)
        expect(hand.score).to eq(4)
      end
    end

    context "when the hand is three of a kind" do
      it "scores 3" do
        hand = Hand.new([four_of_s, four_of_d, four_of_c, jack_of_s, ten_of_s].shuffle)
        expect(hand.score).to eq(3)
      end
    end

    context "when the hand is two pair" do
      it "scores 2" do
        hand = Hand.new([queen_of_d, four_of_s, queen_of_s, four_of_h, ten_of_s].shuffle)
        expect(hand.score).to eq(2)
      end
    end

    context "when the hand is jacks or better" do
      it "scores 1" do
        hand = Hand.new([queen_of_d, two_of_s, queen_of_s, jack_of_s, ten_of_s].shuffle)
        expect(hand.score).to eq(1)
      end
    end

    context "when the hand is nothing" do
      it "scores 0" do
        hand = Hand.new([four_of_s, two_of_s, four_of_d, jack_of_s, ten_of_s].shuffle)
        expect(hand.score).to eq(0)
      end
    end
  end
end