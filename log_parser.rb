require_relative 'file_search'
require_relative 'utils/helper_methods'

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
    last_file = f_search.last_fileno
    while cur_file <= last_file
      file_path = HelperMethods.generate_file_name(cur_file, parent_dir)
      file = File.open(file_path)
      file.readlines.each do |line|
        time = get_timestamp(line)

        if time < start_time
          next
        elsif time <= end_time
          got = true
          out(line)
        else
          file.close
          break
        end
      end

      cur_file += 1
    end
    puts "ERROR! we don't have logs for given time range" unless got

    return @output_lines
  end


  def get_timestamp(log)
    time = log[0...log.index(',')]
    HelperMethods.to_time(time)
  end

  def out(line)
    if @output_method == 'console'
      p line
    else
      @output_lines << line
    end
  end


end