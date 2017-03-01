require 'highline'
require_relative './player_pool'

module Tournament
  # This class is responsible for filling in all the blanks for the supplied
  # partial tournament bracket. Blank data includes any matches that were
  # determined to be necessary, but weren't assiged a player (either home or
  # away) - player assignment will occur automatically. This class will also
  # prompt the user to decide on the outcome for every match in the bracket
  # using a CLI.
  class Input
    attr_accessor :tree

    def initialize(bracket)
      rounds = bracket.tree.group_by { |t| t[:round] }
      rounds.each do |round, matches|
        puts "Round: #{round}"
        previous_round = rounds[round - 1] || []
        players = previous_round.map { |match| match[:winner] }
        player_pool = PlayerPool.new(players)
        matches.each do |match|
          options = [match[:home], match[:away]]
          options.map! { |o| o || player_pool.take_random } if player_pool
          match[:winner] = cli.choose(*options) do |menu|
            menu.select_by = :index
          end
          # re-assign home & away in case they were assigned in this iteration
          match[:home] = options[0]; match[:away] = options[1]
        end
      end
      # un-group the tournament tree
      @tree = (rounds.map { |_, round| round }).flatten
    end

    private

    def cli
      @cli ||= HighLine.new
    end
  end
end
