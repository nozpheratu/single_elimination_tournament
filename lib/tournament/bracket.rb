require_relative './player_pool'

module Tournament
  class Bracket
    attr_reader :tree

    def initialize(contestants)
      @players_pool = Tournament::PlayerPool.new(contestants)
      rounds = power_of_two?(initial_count) ? generate_bye_rounds : generate_rounds
      @tree = rounds.flatten
    end

    private

    def power_of_two?(number)
      number != 0 && number & (number - 1) == 0
    end

    def initial_count
      @initial_count ||= @players_pool.remaining
    end

    def required_rounds
      @required_rounds = Math.log2(initial_count).ceil
    end

    def generate_bye_rounds
      # "Byes" need to be added if the number of participants is not a power of
      # two. See https://en.wikipedia.org/wiki/Bye_%28sports%29
      rounds = []
      byes = (2 ** required_rounds) - initial_count
      bye_pool_players = byes.times.map { @players_pool.take_random }
      bye_pool = Tournament::PlayerPool.new(bye_pool_players)
      # There will always be at minimum two rounds if the registration initial_count
      # is not devisible by two.
      # Setup round 1
      rounds << (@players_pool.remanining / 2).times.map do
        {
          :round => 1,
          :home_id => @players_pool.take_random,
          :away_id => @players_pool.take_random
        }
      end
      # Setup round 2
      rounds << ((byes + ((initial_count - byes))/2) / 2).times.map do
        {
          :round => 2,
          :home_id => bye_pool.take_random,
          :away_id => (bye_pool.take_random if bye_pool.remaining > rounds[0].length)
        }
      end
      # Handle any remaining rounds
      rounds_remaining = required_rounds - rounds.size
      rounds_remaining.times do |round|
        rounds << (rounds.last.size / 2).times.map do
          { :round => (round + 1) + 2, :home_id => nil, :away_id => nil }
        end
      end
      rounds
    end

    def generate_rounds
      rounds = []
      round_i = initial_count
      (required_rounds).times do |i|
        rounds << (round_i /= 2).times.map do
          {
            :round => i + 1,
            :home_id => @players_pool.take_random,
            :away_id => @players_pool.take_random
          }
        end
      end
      rounds
    end
  end
end
