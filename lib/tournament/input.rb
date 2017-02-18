require 'highline'

module Tournament
  class Input
    attr_accessor :data

    def initialize
      cli = HighLine.new
      name = cli.ask("Winner Name?  ", String)
      cli.say("This should be <%= color('#{name}', BOLD) %>!")
      @data = name
    end
  end
end
