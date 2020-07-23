require 'time'

class Helper
  FILENO_LEN = 2
  def initialize

  end

  def self.generate_file_name(file_index, parent_dir)
    parent_dir + "/LogFile-" + file_index.to_s.rjust(FILENO_LEN,"0") + ".log"
  end

  def self.file_index(file_name)
    (file_name.split("/")[-1].split("-")[-1].split(".")[0]).to_i
  end

  def self.recent_logfile(dir_path)
    spath = dir_path + "/*.log"
    index = Dir[spath].length - 1
    generate_file_name(index, "../logs")
  end

  def self.to_utc(time_inp)
    time_inp.utc
  end

  def self.to_time(t_str)
    t = Time.parse(t_str)
    t.utc
  end

end

