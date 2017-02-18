require 'spec_helper'

describe Tournament do
  describe "run" do
    subject { Tournament.run(path) }
    context "given an invalid path to a csv" do
      let(:path) { "non_existant_path" }
      it 'raises a descriptive error' do
        expect {subject}.to raise_error "File Not Found"
      end
    end
  end
end
