require_relative '../opt_parser'
require_relative '../helper_methods'

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

    it "returns hash containing time range and directory to search in" do
      from_t = "2:30"
      to_t = "6:30"
      dir = "../logs"
      options = OptParser.parse(["-f", from_t, "-t", to_t, "-i", dir])
      expect(options).to match_array([[:from, Time.parse(from_t)],[:to, Time.parse(to_t)], [:directory, dir]])
    end

  end
end
