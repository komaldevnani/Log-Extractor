require 'time'
require_relative 'helper_methods'
require_relative 'logfile'

class FileSearch
  def binary_search_file (start_time, parent_dir)
    last_file = Helper.recent_logfile(parent_dir)
    last_fileno = Helper.file_index(last_file)
    @start_fileno = 0

    while last_fileno >= @start_fileno
      mid_fileno = (last_fileno + @start_fileno) / 2

      file_path = Helper.generate_file_name(mid_fileno, parent_dir)
      log_file = Logfile.new(file_path)

      first_timestamp = Helper.to_time(log_file.top_timestamp)
      last_timestamp = Helper.to_time(log_file.last_timestamp)

      if in_range(start_time, first_timestamp, last_timestamp)
        return mid_fileno
      elsif start_time < first_timestamp
        last_fileno = mid_fileno - 1
      else
        @start_fileno = mid_fileno + 1
      end
    end
    return mid_fileno
  end

  private

  def in_range(time, s_time, e_time)
    (s_time..e_time).cover?(time)
  end
end
