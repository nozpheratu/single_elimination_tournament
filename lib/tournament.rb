require_relative 'tournament/bracket'
require_relative 'tournament/input'
require_relative 'tournament/graph'
require 'csv'
require 'ap'

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
      names = Array.new
      CSV.foreach(@file) do |field|
        names << field[0]
      end
      names
    rescue
      raise "File Not Found"
    end
  end
end
