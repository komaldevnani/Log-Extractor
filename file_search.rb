class FileSearch
  def self.recent_logfile (dir_path)
    spath = dir_path + "/*.log"
    Dir.glob(spath).max_by {|f| File.mtime(f)}
  end

  def self.binary_search_file ( start_time, parent_dir)
    last_file = recent_logfile(parent_dir)
    last_fileno = (last_file.split("/")[-1].split("-")[-1]).to_i
    start_fileno = 0

    while last_fileno > start_fileno
      mid_fileno = (last_fileno + start_fileno) * 0.5

      file_path = parent_dir + "/LogFile-" + mid_fileno
      file_data = File.open(file_path, &:readline)
      time_in_first_line = file_data[0...file_data.index(',')]
      time_in_first_line = Time.parse(time_in_first_line).iso8601

      if time_in_first_line == start_time
        return mid_fileno
      elsif time_in_first_line > start_time
        last_fileno = mid_fileno - 1
      else
        start_fileno = mid_fileno + 1
      end

      if last_fileno == start_fileno
        return last_fileno
      end
    end
  end
end
