require_relative '../opt_parser'
require 'optparse'

describe OptParser do
  describe ".parse" do

    context "given zero arguments" do
      it "prints help message" do
        expect(OptParser.parse([])).to eq(puts parser)
      end
    end

    context "given -h or --help argument" do
      it "prints parser object" do
        expect(OptParser.parse(["-h"])).to eq(puts parser)
      end
    end

  end
end