module Tournament
  class Bracket
    attr_reader :tree

    def initialize(contestants)
      @registrants_pool = contestants
      rounds = power_of_two?(count) ? generate_bye_rounds : generate_rounds
      @tree = rounds.flatten
    end

    private

    def power_of_two?(number)
      number != 0 && number & (number - 1) == 0
    end

    def count
      @count ||= @registrants_pool.count
    end

    def required_rounds
      @required_rounds = Math.log2(count).ceil
    end

    def generate_bye_rounds
      # "Byes" need to be added if the number of participants is not a power of
      # two. See https://en.wikipedia.org/wiki/Bye_%28sports%29
      rounds = []
      byes = (2 ** required_rounds) - count
      bye_pool = byes.times.map {@registrants_pool.delete_at(rand(@registrants_pool.length))}
      # There will always be at minimum two rounds if the registration count
      # is not devisible by two.
      # Setup round 1
      rounds << (@registrants_pool.length / 2).times.map do
        {
          :round => 1,
          :home_id => @registrants_pool.delete_at(rand(@registrants_pool.length)),
          :away_id => @registrants_pool.delete_at(rand(@registrants_pool.length))
        }
      end
      # Setup round 2
      rounds << ((byes + ((count - byes))/2) / 2).times.map do
        {
          :round => 2,
          :home_id => bye_pool.delete_at(rand(bye_pool.length)),
          :away_id => bye_pool.length > rounds[0].length ?  bye_pool.delete_at(rand(bye_pool.length)) : nil
        }
      end
      # Handle any remaining rounds
      rounds_remaining = required_rounds - rounds.size
      rounds_remaining.times do |round|
        rounds << (rounds.last.size / 2).times.map { { :round => (round + 1) + 2, :home_id => nil, :away_id => nil } }
      end
      rounds
    end

    def generate_rounds
      rounds = []
      round_i = count
      (required_rounds).times do |i|
        rounds << (round_i /= 2).times.map do |x|
          {
            :round => i + 1,
            :home_id => @registrants_pool.delete_at(rand(@registrants_pool.length)),
            :away_id => @registrants_pool.delete_at(rand(@registrants_pool.length))
          }
        end
      end
      rounds
    end
  end
end
