require 'graph'
require 'fileutils'

module Tournament
  class Graph
    def initialize(bracket_tree)
      @bracket_tree = bracket_tree
      generate if @bracket_tree.any?
    end

    private

    def generate
      matches = @bracket_tree
      path = "./graph"
      FileUtils.mkdir(path) unless File.exists? path
      final = @bracket_tree.sort {|match| match[:round]}.first
      digraph do |x, &block|
        boxes
        label("Single Elimination Tournament")
        orient "LR"
        colour = 0
        colorscheme(:pubu, 8)
        graph_attribs << "labelloc=\"t\""
        edge_attribs << ["arrowhead=none", "arrowtail=none", "style=bold"]
        node_attribs << filled

        # Node & edge setup
        matches.each do |match|
          match_edge = matches.find {|e| e[:round] == match[:round] + 1 && [e[:home_id], e[:away_id]].include?(match[:winner_id])}
          node(match.object_id).label "#{match[:home_id]}\nvs.\n#{match[:away_id]}"
          edge match.object_id, match_edge.object_id unless match_edge.nil?
        end

        node("winner").label final[:winner_id]

        edge final.object_id, "winner"

        # Assigns up to 8 rounds a unique colour
        matches.sort {|match| match[:round]}.reverse.group_by{|match| match[:round]}.map do |round, round_matches|
          colour += 1 unless colour >= 8
          round_matches.each do |match|
            unless match[:winner_id].nil?
              eval("c#{colour}") << node(match.object_id)
            end
          end
          eval("c#{colour + 1}") << node("winner")
        end
        #save as svg and fallback png
        save "#{path}/graph", "svg"
        save "#{path}/graph", "png"
      end
    end
  end
end
