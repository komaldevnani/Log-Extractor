require_relative 'file_search'
require_relative 'helper_methods'

class LogParser
  SUPPORTED_OUTPUT_METHODS = ['console', 'return']
  def initialize(output_method = 'console')
    raise ArgumentError unless SUPPORTED_OUTPUT_METHODS.include?(output_method)

    @output_method = output_method

    @output_lines = []

  end

  def logs_in_range(start_time, end_time, parent_dir)
    f_search = FileSearch.new
    from_fileno = f_search.binary_search_file(start_time, parent_dir)
    cur_file = from_fileno

    got = false
    last_file = Helper.file_index(Helper.recent_logfile(parent_dir))

    while cur_file <= last_file
      file_path = Helper.generate_file_name(cur_file, parent_dir)
      file = File.new(file_path)
      file.each do |line|
        time = get_timestamp(line)

        if time < start_time
          next
        elsif time <= end_time
          got = true
          out(line)
        else
          break
        end
      end

      cur_file += 1
    end
    puts "ERROR! we don't have logs for given time range" unless got
    return @output_lines
  end

  private

  def get_timestamp(log)
    time = log[0...log.index(',')]
    Helper.to_time(time)
  end

  def out(line)
    if @output_method == 'console'
      p line
    else
      @output_lines << line
    end
  end
end