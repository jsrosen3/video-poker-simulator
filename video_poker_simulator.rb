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

class Hand
  HAND_SCORES = {"Royal Flush" => 250,
                 "Straight Flush" => 50,
                 "Four of a Kind" => 25,
                 "Full House" => 9,
                 "Flush" => 6,
                 "Straight" => 4,
                 "Three of a Kind" => 3,
                 "Two Pair" => 2,
                 "Jacks or better" => 1}

  def initialize(hand)
    @hand = hand
  end
  
  def update_cards(indices_to_remove, deck)
    indices_to_remove.each { |index| @hand[index] = deck.deck.pop }
    self
  end
  
  def inspect
    @hand.each.map(&:inspect).join(' ')
  end
  
  def score
    if straight? && flush?
      card_numbers = self.map { |card| card.number }.sort
      return (card_numbers == [10, 11, 12, 13, 14] ? HAND_SCORES["Royal Flush"] : HAND_SCORES["Straight Flush"])
    elsif straight?
      return HAND_SCORES["Straight"]
    elsif flush?
      return HAND_SCORES["Flush"]
    end

    freqs = get_frequencies.values.sort
    if freqs == [1,4]
      return HAND_SCORES["Four of a Kind"]
    elsif freqs == [2,3]
      return HAND_SCORES["Full House"]
    elsif freqs == [1,1,3]
      return HAND_SCORES["Three of a Kind"]
    elsif freqs == [2,2]
      return HAND_SCORES["Two Pair"]
    elsif freqs == [1,1,1,2]
      return HAND_SCORES["Jacks or Better"]
    else
      return 0
    end
  end
  
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
end







class Player
  attr_accessor :hand
  
  def initialize(name)
    @hand = nil
    @name = name
  end
  
  def choose_cards_to_remove
    p @hand
    puts "#{@name}, please enter the indices of the cards to discard."
    puts "(Example: 1,3,4)"
    cards_to_remove = gets.chomp.split(',').map! { |num| num.to_i - 1 }
  end

end


class Game
  attr_accessor :deck
  
  def initialize
    @deck = Deck.new
    @players = get_players
  end
  
  def get_players
    players = []
    puts "Enter the player's name. If no more players, enter 'done'."
    name = gets.chomp
    until name == 'done'
      players << Player.new(name)
      puts "Enter the player's name. If no more players, enter 'done'."
      name = gets.chomp
    end
    players
  end
  
  def play
    deal_cards
    cards_to_remove = get_cards_to_remove
    scores = score_all_hands(cards_to_remove)
    report_scores(scores)
  end
  
  def deal_cards
    @players.each { |player| player.hand = @deck.deal_hand }
  end
  
  def get_cards_to_remove
    cards_to_remove = {}
    @players.each do |player|
      cards_to_remove[player] = player.choose_cards_to_remove
    end
    cards_to_remove
  end

  def score_all_hands(cards_to_remove)
    scores = {}
    @players.each do |player|
      player_score = 0
      1000.times do
        player_score += score_hand_once(player, cards_to_remove[player])
      end
      player_score /= 1000.0
      scores[player] = player_score
    end
    scores
  end

  def score_hand_once(player, cards_to_remove)
    permanent_deck = @deck
    score = player.hand.update_cards(cards_to_remove, @deck).score
    @deck = permanent_deck
    score
  end

  def report_scores(scores)
    scores.each { |player, score| puts "#{player.name}'s score: #{score.round(2)}"
  end
end

