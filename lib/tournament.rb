require_relative 'tournament/renderer'
require_relative 'tournament/bracket'
require 'csv'

module Tournament
  class << self
    def run(path)
      contestants = parse_names(path)
      puts contestants
      bracket = Bracket.new(contestants)
      puts bracket.tree
      puts bracket.tree.length
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
