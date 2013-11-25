require './card.rb'
require './deck.rb'
require './hand.rb'
require './player.rb'

class Game
  NUM_SIMULATIONS = 20000

  attr_accessor :deck
  
  def initialize
    @deck = Deck.new
    @players = get_players
    play
  end
  
  def get_players
    players = []
    puts "\n"
    puts "Enter the player's name. If no more players, enter 'done'."
    name = gets.chomp
    until name == 'done' && !players.empty?
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
    play_again?
  end

  def play_again?
    puts "\nPlay again? (y/n)"
    input = gets.chomp
    if input == 'n'
      puts "\nThanks for playing!"
      exit
    else 
      play
    end
  end
  
  def deal_cards
    hand = @deck.deal_hand
    @players.each { |player| player.hand = hand }
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
      NUM_SIMULATIONS.times do |j|
        player_score += score_hand_once(player, cards_to_remove[player])
      end
      player_score /= NUM_SIMULATIONS.to_f
      scores[player] = player_score
    end
    scores
  end

  def score_hand_once(player, cards_to_remove)
    permanent_deck = @deck.deck.clone
    permanent_hand = player.hand
    score = permanent_hand.update_cards(cards_to_remove, @deck.deck).score
    @deck.deck = permanent_deck
    player.hand = permanent_hand
    score
  end

  def report_scores(scores)
    puts "\n"
    scores.each { |player, score| puts "#{player.name}'s score: #{score.round(3)}" }
  end
end

Game.new