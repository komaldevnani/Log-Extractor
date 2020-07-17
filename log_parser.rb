class LogParser
  def self.print_logs(start_time, end_time, parent_dir)
    from_fileno = binary_search_file(start_time, parent_dir)
    read_file = 0
    more = true

    while more
      file_path = parent_dir + "/LogFile-" + (from_fileno+read_file)
      File.each_line(file_path) do |line|
        time = line[0...line.index(',')]
        time = Time.iso8601(time)

        if time < start_time
          next
        elsif time <= end_time
          p line
        else
          File.close()
          more = false
          break
        end
      end

      read_file += 1
    end

  end
end