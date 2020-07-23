class Logfile
  def initialize (filepath)
    @file_path = filepath
  end

  def top_timestamp
    file_data = File.open(@file_path, &:readline)
    file_data[0...file_data.index(',')]
  end

  def last_timestamp
    fp = File.open(@file_path,'r')
    pos = -1
    loop do
      pos -= 1
      fp.seek(pos, IO::SEEK_END)
      char = fp.read(1)

      if eol?(char)
        break
      end

    end
    line = fp.read
    fp.close
    line[0...line.index(',')]
  end

  def eol?(char)
    char == "\n"
  end
end