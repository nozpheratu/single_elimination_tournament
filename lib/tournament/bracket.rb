require_relative './player_pool'

module Tournament
  # This class is responsible for transforming a list of players to an array of
  # matches in a single elimination competition bracket format. It will
  # automatically determine the initial match lineup and give players "byes" for
  # the first round (see https://en.wikipedia.org/wiki/Bye_%28sports%29) to
  # balance the bracket such there there will be an even number of participants
  # for the semifinal & final rounds.
  class Bracket
    attr_reader :tree

    def initialize(contestants)
      @players_pool = Tournament::PlayerPool.new(contestants)
      rounds = power_of_two?(initial_count) ? generate_rounds : generate_bye_rounds
      @tree = rounds.flatten
    end

    private

    def power_of_two?(number)
      (number.nonzero? && number & (number - 1)).zero?
    end

    def initial_count
      @initial_count ||= @players_pool.remaining
    end

    def required_rounds
      @required_rounds = Math.log2(initial_count).ceil
    end

    def byes
      (2**required_rounds) - initial_count
    end

    def generate_bye_rounds
      rounds = []
      bye_pool_players = Array.new(byes) { @players_pool.take_random }
      bye_pool = Tournament::PlayerPool.new(bye_pool_players)
      rounds << Array.new(@players_pool.remaining / 2) do
        {
          round: 1,
          home:  @players_pool.take_random,
          away:  @players_pool.take_random
        }
      end
      rounds << Array.new((byes + (initial_count - byes) / 2) / 2) do
        {
          round: 2,
          home:  bye_pool.take_random,
          away:  (bye_pool.take_random if bye_pool.remaining > rounds[0].length)
        }
      end
      # Handle any remaining rounds
      rounds_remaining = required_rounds - rounds.size
      rounds_remaining.times do |round|
        rounds << Array.new(rounds.last.size / 2) do
          { round:  (round + 1) + 2, home:  nil, away: nil }
        end
      end
      rounds
    end

    def generate_rounds
      rounds = []
      round_i = initial_count
      required_rounds.times do |i|
        rounds << Array.new(round_i /= 2) do
          {
            round: i + 1,
            home:  @players_pool.take_random,
            away:  @players_pool.take_random
          }
        end
      end
      rounds
    end
  end
end
