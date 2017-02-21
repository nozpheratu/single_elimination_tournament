require 'csv'
require_relative 'tournament/bracket'
require_relative 'tournament/input'
require_relative 'tournament/graph'

# The program takes a path to a CSV containing a line-delimited list of users to
# be used as players for a single elimitation style tournament. The program will
# automatically setup the tournament bracket and the user will be prompted to
# select the outcome for each successive match. When all match outcomes have
# been decided, a tournament bracket/tree digram will be generated depicting the
# results of the tournament.
#
# Author::    Dave Thomas  (mailto:dave@x.y)
# Copyright:: Copyright (c) 2002 The Pragmatic Programmers, LLC
# License::   Distributes under the same terms as Ruby

# This class accepts a path to a CSV, parses the CSV into a collection of player
# names and then passes the player names down the pipeline for bracket
# generation, outcome specification, and finally graph generation.
module Tournament
  class << self
    def run(path)
      contestants = parse_names(path)
      partial_bracket = Bracket.new(contestants)
      complete_bracket = Input.new(partial_bracket)
      Graph.new(complete_bracket.tree)
    end

    private

    def parse_names(path)
      @file = File.join(path)
      names = []
      CSV.foreach(@file) do |field|
        names << field[0]
      end
      names
    rescue
      raise "File Not Found"
    end
  end
end
