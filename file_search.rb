require 'time'
require_relative 'utils/helper_methods'
require_relative 'logfile'

class FileSearch
  attr_accessor :last_fileno
  def binary_search_file (start_time, parent_dir)
    last_file = recent_logfile(parent_dir)
    @last_fileno = file_index(last_file)
    @start_fileno = 0

    while @last_fileno >= @start_fileno
      mid_fileno = (@last_fileno + @start_fileno) / 2

      file_path = HelperMethods.generate_file_name(mid_fileno, parent_dir)
      log_file = Logfile.new(file_path)

      first_timestamp = HelperMethods.to_time(log_file.top_timestamp)
      last_timestamp = HelperMethods.to_time(log_file.last_timestamp)

      if in_range(start_time, first_timestamp, last_timestamp)
        return mid_fileno
      elsif start_time < first_timestamp
        @last_fileno = mid_fileno - 1
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

  def file_index(file_name)
    (file_name.split("/")[-1].split("-")[-1].split(".")[0]).to_i
  end

  def recent_logfile(dir_path)
    spath = dir_path + "/*.log"
    Dir.glob(spath).max_by {|f| File.mtime(f)}
  end

end
