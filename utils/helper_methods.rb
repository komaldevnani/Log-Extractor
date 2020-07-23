class HelperMethods
FILENO_LEN = 2

  def self.generate_file_name(file_index, parent_dir)
    parent_dir + "/LogFile-" + file_index.to_s.rjust(FILENO_LEN,"0") + ".log"
  end

  def self.to_utc(time_inp)
    time_inp.utc
  end

  def self.to_time(str)
    Time.parse(str).utc
  end

end
