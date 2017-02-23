require 'graph'

module Tournament
  # The Graph class is responsible for generating application output in the form
  # of a SVG + PNG diagram depicting the tournament bracket. It utilizes the
  # graph ruby DSL for Graphviz to acomplish this.
  class Graph
    attr_reader :bracket

    def initialize(bracket)
      @bracket = bracket
      generate if @bracket.any?
    end

    private

    def generate
      klass = self # Accommodate the context change in digraph hash
      final = @bracket.sort { |match| match[:round] }.first
      digraph do
        # General graph configuration
        label("Single Elimination Tournament")
        boxes; orient "LR"; colour = 0; colorscheme(:pubu, 8)
        graph_attribs << "labelloc=\"t\""
        edge_attribs << ["arrowhead=none", "arrowtail=none", "style=bold"]
        node_attribs << filled

        # Assigns up to 8 rounds a unique colour
        sorted_matches = klass.bracket.sort { |match| match[:round] }.reverse
        sorted_matches.group_by { |match| match[:round] }.map do |_, round_matches|
          colour += 1 unless colour >= 8
          round_matches.each do |match|
            unless match[:winner].nil?
              eval("c#{colour}") << node(match.object_id)
            end
          end
          eval("c#{colour + 1}") << node("winner")
        end

        # Node & edge setup
        klass.bracket.each do |match|
          match_edge = klass.bracket.find do |e|
            e[:round] == match[:round] + 1 && [e[:home], e[:away]].include?(match[:winner])
          end
          node(match.object_id).label "#{match[:home]}\nvs.\n#{match[:away]}"
          edge match.object_id, match_edge.object_id unless match_edge.nil?
        end

        # Setup the final winner node
        node("winner").label final[:winner]
        edge final.object_id, "winner"

        save "./graph/graph", "svg"
        save "./graph/graph", "png"
      end
    end
  end
end
