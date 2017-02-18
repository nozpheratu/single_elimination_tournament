require_relative 'tournament/renderer'
require_relative 'tournament/input'

module Tournament
  class << self
    def run
      input = Input.new
      Renderer.new(input)
    end
  end
end
