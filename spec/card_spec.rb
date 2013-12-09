describe "Card" do 

  describe "#initialize" do
    subject(:card) { Card.new(rand(2..14), ['c', 'h', 's', 'd'].sample) }

    it "should be initialized with a suit and a number" do
      expect(card.suit).to_not be_nil
      expect(card.number).to_not be_nil
    end
  end
end