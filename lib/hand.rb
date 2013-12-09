class Hand
  attr_accessor :hand

  HAND_SCORES = {"Royal Flush" => 250,
                 "Straight Flush" => 50,
                 "Four of a Kind" => 25,
                 "Full House" => 9,
                 "Flush" => 6,
                 "Straight" => 4,
                 "Three of a Kind" => 3,
                 "Two Pair" => 2,
                 "Jacks or Better" => 1}

  def initialize(hand)
    @hand = hand
  end
  
  def update_cards(indices_to_remove, deck)
    deck.shuffle!
    indices_to_remove.each { |index| @hand[index] = deck.pop }
    self
  end
  
  def inspect
    @hand.each.map(&:inspect).join(' ')
  end
  
  def score
    if straight? && flush?
      card_numbers = self.hand.map { |card| card.number }.sort
      return (card_numbers == [10, 11, 12, 13, 14] ? HAND_SCORES["Royal Flush"] : HAND_SCORES["Straight Flush"])
    elsif straight?
      return HAND_SCORES["Straight"]
    elsif flush?
      return HAND_SCORES["Flush"]
    end

    numbers_and_freqs = get_frequencies
    freqs = numbers_and_freqs.values.sort
    if freqs == [1,4]
      return HAND_SCORES["Four of a Kind"]
    elsif freqs == [2,3]
      return HAND_SCORES["Full House"]
    elsif freqs == [1,1,3]
      return HAND_SCORES["Three of a Kind"]
    elsif freqs == [1,2,2]
      return HAND_SCORES["Two Pair"]
    elsif freqs == [1,1,1,2] && jacks_or_better?(numbers_and_freqs)
      return HAND_SCORES["Jacks or Better"]
    else
      return 0
    end
  end
  
  private

  def get_frequencies
    frequencies = Hash.new(0)
    nums = @hand.map { |card| card.number }
    nums.each { |num| frequencies[num] += 1 }
    frequencies
  end
  
  def flush?
    suit = @hand[0].suit
    @hand.all? { |card| card.suit == suit}
  end
  
  def straight?
    card_numbers = @hand.map{ |card| card.number }.sort
    (card_numbers.first..(card_numbers.first + 4)).to_a == card_numbers ||
    card_numbers ==[2, 3, 4, 5, 14]
  end 

  def jacks_or_better?(freqs)
    card_numbers = @hand.map{ |card| card.number }
    paired_number = freqs.sort_by { |k, v| v }.last.first
    [11, 12, 13, 14].include?(paired_number) ? true : false
  end
end