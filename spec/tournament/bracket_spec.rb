require "spec_helper"

describe Tournament::Bracket do
  let(:bracket) { Tournament::Bracket.new(players) }
  describe "#tree" do
    subject {bracket.tree.length}

    context "given 4 players" do
      let(:players) { ["player"] * 4 }

      it { is_expected.to eq 3 }
    end
  end
end
