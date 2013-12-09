require 'rspec'
require 'player.rb'

describe "Player" do 

  describe "#initialize" do
    subject(:player) { Player.new("Chris Moneymaker") }

    it "should be initialized with a name" do
      expect(player.name).to eq "Chris Moneymaker"
    end

    it "should not have a hand" do
      expect(player.hand).to be_nil
    end
  end
end