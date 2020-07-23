require_relative '../opt_parser'
require_relative '../log_parser'
require 'optparse'
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
describe LogParser do
  def make_parent_dir
    Dir.mkdir("../logs") unless Dir.exist?("../logs")
  end

  def generate_file(file_index, line_list)
    make_parent_dir
    parent_dir = "../logs"
    helper = HelperMethods.new
    file_name = helper.generate_file_name(file_index,parent_dir)
    file = File.open(file_name, "w")
    line_list.each do |line|
      full_line = line.join(",") + "\n"
      file << full_line
    end
    file.close()
    return file
  end

  def convert_ts_list_to_line_list(ts_list)
    ts_list.map { |ts| [ts, ts] }
  end

  def generate_file_with_payload(file_index, ts_list)
    line_list = convert_ts_list_to_line_list(ts_list)
    return generate_file(file_index, line_list)
  end

  describe ".parse" do

    def generate_files
      # generate_file(
      #   '0',
      #   [
      #     ['2018-10-10 10:10:05', '10@10@05'],
      #     ['2018-10-10 10:10:06', '2'],
      #     ['2018-10-10 10:10:08', '2'],
      #     ['2018-10-10 10:10:10', '2'],
      #     ['2018-10-10 10:10:20', '2']
      #   ]
      # )
      # generate_file(
      #   '1',
      #   [
      #     ['2018-10-10 10:10:20', '1'],
      #     ['2018-10-10 10:10:30', '2'],
      #     ['2018-10-10 10:10:40', '2'],
      #     ['2018-10-10 10:10:50', '2'],
      #     ['2018-10-10 10:11:05', '2']
      #   ]
      # )
      generate_file_with_payload('0', ['2018-10-10T10:10:05.1234Z', '2018-10-10T10:20:06.1234Z', '2018-10-10T10:30:08.1234Z'])
      generate_file_with_payload('1', ['2018-10-10T20:10:05.1234Z', '2018-10-10T20:20:06.1234Z', '2018-10-10T20:30:08.1234Z'])
      generate_file_with_payload('2', ['2018-11-10T10:10:05.1234Z', '2018-11-10T10:20:06.1234Z', '2018-11-10T10:30:08.1234Z'])
      generate_file_with_payload('3', ['2018-11-11T20:12:05.1234Z', '2018-11-11T20:14:06.1234Z', '2018-11-11T20:18:08.1234Z'])
      generate_file_with_payload('4', ['2018-12-12T10:12:05.1234Z', '2018-12-12T10:14:06.1234Z', '2018-12-12T10:18:08.1234Z'])
      generate_file_with_payload('5', ['2018-12-13T20:14:05.1234Z', '2018-12-13T20:16:06.1234Z', '2018-12-13T20:18:08.1234Z'])
      generate_file_with_payload('6', ['2018-12-14T10:12:05.1234Z', '2018-12-14T10:14:06.1234Z', '2018-12-14T10:18:08.1234Z'])
      generate_file_with_payload('7', ['2018-12-15T20:12:05.1234Z', '2018-12-15T20:14:06.1234Z', '2018-12-15T20:18:08.1234Z'])
      generate_file_with_payload('8', ['2018-12-16T10:12:05.1234Z', '2018-12-16T10:14:06.1234Z', '2018-12-16T10:18:08.1234Z'])
    end

    def teardown(parent_dir)
      Dir[parent_dir + "/*.logs"].each do |file|
        File.delete(file)
      end
    end

    before(:each) do
      generate_files
    end

    after(:each) do
      teardown("../logs") # deletes file
    end



   it 'Searches for logs across files' do
      start_date = Time.parse("2018-11-10 15:20:05").utc
      end_date = Time.parse("2018-11-10 16:00:08").utc
      directory = "../logs"
      log_parser = LogParser.new("return")
      lines = log_parser.logs_in_range(start_date, end_date, directory)



      payloads = lines.map { |x| x.split(",")[1] }
      expect(payloads).to match_array(["2018-11-10T10:10:05.1234Z\n", "2018-11-10T10:20:06.1234Z\n"])

   end
    it 'Prints logs from more than one file' do
      start_date = Time.parse("2018-11-10 15:20:05").utc
      end_date = Time.parse("2018-11-12 10:12:08").utc
      directory = "../logs"
      log_parser = LogParser.new("return")
      lines = log_parser.logs_in_range(start_date, end_date, directory)



      payloads = lines.map { |x| x.split(",")[1] }
      expect(payloads).to match_array(["2018-11-10T10:10:05.1234Z\n", "2018-11-10T10:20:06.1234Z\n","2018-11-10T10:30:08.1234Z\n",
                                       "2018-11-11T20:12:05.1234Z\n", "2018-11-11T20:14:06.1234Z\n","2018-11-11T20:18:08.1234Z\n","2018-11-11T20:12:05.1234Z\n"])
    end
  end


end
