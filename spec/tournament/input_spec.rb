require 'spec_helper'

RSpec.shared_examples "a valid tree" do
  let(:partial_tree) { double(tree: assigned_tree) }
  it 'has no nil values' do
    completed_tree = Tournament::Input.new(partial_tree).tree
    expect(completed_tree).to_not include nil
  end

  it "has a winner is assigned on each match" do
    completed_tree = Tournament::Input.new(partial_tree).tree
    expect(completed_tree.map{|m| m[:winner]}.length).to eq assigned_tree.length
  end
end

describe Tournament::Input do
  let(:partial_tree) { double(tree: assigned_tree) }
  let(:tree) { [{round: 1, home: "A", away: "B"}, {round: 1, home: "C", away: "D"}] }
  let(:tree_with_byes ) do
    Tournament::Bracket.new(["player"] * 15).tree
  end

  describe '#tree' do
    # stub the CLI prompt so these tests can run autonomously
    before {
      allow_any_instance_of(Tournament::Input).to receive(:cli) { double(choose: 1) }
    }

    context 'without byes' do
      it_behaves_like "a valid tree" do
        let(:assigned_tree) { tree }
      end
    end

    context 'with byes' do
      it_behaves_like "a valid tree" do
        let(:assigned_tree) { tree_with_byes }
      end
    end
  end
end
