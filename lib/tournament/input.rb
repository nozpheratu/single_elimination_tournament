require 'highline'

module Tournament
  class Input
    attr_accessor :data

    def initialize
      @cli = HighLine.new
    end

    def prompt(question)
      @cli.ask(question)
    end
  end
end
