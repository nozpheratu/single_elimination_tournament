module Tournament
  # This class wraps a list of users and presents them such that they cannot be
  # allocated to any given round twice.
  class PlayerPool
    attr_reader :players

    def initialize(players)
      @players = players.dup
    end

    def take_random
      @players.delete_at(rand(@players.length))
    end

    def remaining
      @players.length
    end
  end
end
