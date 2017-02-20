module Tournament
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
