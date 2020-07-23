require_relative '../log_parser'
require_relative '../helper_methods'

describe LogParser do
  def make_parent_dir
    Dir.mkdir("../logs") unless Dir.exist?("../logs")
  end

  def generate_file(file_index, line_list)
    make_parent_dir
    parent_dir = "../logs"
    file_name = Helper.generate_file_name(file_index,parent_dir)
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
                                       "2018-11-11T20:12:05.1234Z\n", "2018-11-11T20:14:06.1234Z\n","2018-11-11T20:18:08.1234Z\n"])
    end
  end
end
