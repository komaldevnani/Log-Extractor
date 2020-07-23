require 'time'

class HelperMethods
  FILENO_LEN = 2
  def initialize

  end

  def generate_file_name(file_index, parent_dir)
    parent_dir + "/LogFile-" + file_index.to_s.rjust(FILENO_LEN,"0") + ".log"
  end

  def file_index(file_name)
    (file_name.split("/")[-1].split("-")[-1].split(".")[0]).to_i
  end

  def recent_logfile(dir_path)
    spath = dir_path + "/*.log"
    # p Dir.glob(spath).max_by {|f| File.mtime(f)}
    index = Dir[spath].length - 1
    generate_file_name(index, "../logs")
  end

  def to_utc(time_inp)
    time_inp.utc
  end

  def to_time(t_str)
    t = Time.parse(t_str)
    t.utc
  end

end

