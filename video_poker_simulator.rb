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
      return 8
    elsif straight?
      return 4
    elsif flush?
      return 5
    end
    freqs = get_frequencies.values.sort
    if freqs == [1,4]
      return 7
    elsif freqs == [2,3]
      return 6
    elsif freqs == [1,1,3]
      return 3
    elsif freqs == [2,2]
      return 2
    elsif freqs == [1,1,1,2]
      return 1
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
  attr_accessor :hand, :money, :name
  
  def initialize(name, money)
    @name = name
    @money = money
    @hand = nil
  end
  
  def choose_cards_to_remove
    p @hand
    puts "#{@name.capitalize}, please enter the indices of the cards"
    puts "that you wish to discard. (Format: 1,3,4)"
    input = gets.chomp.split(',').map! { |num| num.to_i - 1 }
    if input.length > 3
      puts "You can only exchange three or fewer cards." 
      choose_cards_to_remove
    end
  end
  
  def bet
    p @hand
    puts "#{@name.capitalize}, would you like to bet, raise or fold? (b,r,f)"
    input = gets.chomp.to_s
    unless ['b','r','f'].include?(input)
      puts "error: invalid move"
      bet
    end
  end
  
end


class Game
  attr_accessor :deck
  
  def initialize
    @deck = Deck.new
    @players = get_players
    @pot = 0
  end
  
  def get_players
    players = []
    puts "Enter the player's name. If no more players, enter 'done'."
    input = gets.chomp
    until input == 'done' && players.length >= 2
      players << Player.new(input, 100)
      puts "Enter the player's name. If no more players, enter 'done'."
      input = gets.chomp
    end
    players
  end
  
  def play
    deal_cards
    #betting_round
    exchange_cards
    #betting_round
    report_winners
  end
  
  def deal_cards
    @players.each { |player| player.hand = @deck.deal_hand }
    
  end
  
  def betting_round(players_to_bet= @players, pot = 0)
    bet = 
    until players_to_bet.empty?
      current_player = players_to_bet.shift
      case current_player.bet
      when "b"
        bet = play_bet(current_player)
      when "r"
        play_raise
      when "f"
        play_fold
      end
    end
  end
  
  def play_bet(player)
    puts "How much would you like to bet?"
    bet = gets.chomp.to_i
    unless bet.is_a?(Integer) && bet >= 0 && bet <= player.money
      puts "not a valid amount"
      play_bet(player)
    end 
    @pot += bet
    player.money -= bet
    return bet
  end
  
  def play_raise(player)
    puts "How much would you like to raise?"
    bet = gets.chomp.to_i
    unless bet.is_a?(Integer) && bet >= 0 && bet <= player.money
      puts "not a valid amount"
      play_bet(player)
    end 
    @pot += (bet + the_raise)
    player.money -= (bet + the_raise)
    return bet
  end
  
  def play_fold(player)
    puts "You're a quitter."
  end

  def exchange_cards
    @players.each do |player|
      indices = player.choose_cards_to_remove
      player.hand = player.hand.update_cards(indices, @deck)
    end
  end
  
  def report_winners
    winning_players = [@players[0]]
    highest_score = @players[0].hand.score
    @players.each do |player|
      next if player == @players.first
      if player.hand.score == highest_score
        winning_players << player
      elsif player.hand.score > highest_score
        highest_score = player.hand.score
        winning_players = [player]
      end
    end
    winning_names = winning_players.map(&:name).join(' and ')
    puts "Congratulations, #{winning_names}!"
    # pot_share = pot / winning_players.length
    # winning_players.each { |winner| winner.money += pot_share }
    nil
  end
  
end

