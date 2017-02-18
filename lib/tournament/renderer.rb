require 'graph'
require 'fileutils'

module Tournament
  class Renderer
    def initialize(input)
      path = "./graph"
      FileUtils.mkdir(path) unless File.exists? path
      digraph do |x, &block|
        boxes
        label("Comp")
        orient "LR"
        colour = 0
        colorscheme(:pubu, 8)
        graph_attribs << "labelloc=\"t\""
        edge_attribs << ["arrowhead=none", "arrowtail=none", "style=bold"]
        node_attribs << filled

        node("winner").label input.data

        #save as svg and fallback png
        save "#{path}/graph", "svg"
      end
    end
  end
end
