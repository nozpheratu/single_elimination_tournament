require 'spec_helper'

describe Tournament::PlayerPool do
  let(:players) { ["a", "b", "c"] }
  let(:pool) { Tournament::PlayerPool.new(players) }
  describe "#take_random" do
    it "returns a player at random" do
      expect(players).to include pool.take_random
    end

    it "removes a player from the pool" do
      player = pool.take_random
      expect(pool.players).to_not include player
    end
  end

  describe "#remaning" do
    it "returns the number of players" do
      expect(pool.remaining).to eq pool.players.length
    end
  end
end
