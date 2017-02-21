require_relative './player_pool'
require 'highline'
require 'ap'

module Tournament
  class Input
    attr_accessor :tree

    def initialize(bracket)
      rounds = bracket.tree.group_by {|t| t[:round] }
      rounds.each do |round, matches|
        ap "Round: #{round}"
        previous_round = rounds[round - 1] || []
        players = previous_round.map {|match| match[:winner_id] }
        player_pool = PlayerPool.new(players)
        matches.each do |match|
          options = [match[:home_id], match[:away_id]]
          options.map! { |o| o || player_pool.take_random } if player_pool
          match[:winner_id] = cli.choose(*options) do |menu|
            menu.select_by = :index
          end
          # re-assign home & away in case they were assigned in this iteration
          match[:home_id] = options[0] ; match[:away_id] = options[1]
        end
      end
      # un-group the tournament tree
      @tree = (rounds.map {|_, round| round}).flatten
    end

    private

    def cli
      @cli ||= HighLine.new
    end
  end
end
