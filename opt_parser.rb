require 'optparse'
require 'optparse/time'

class OptParser
  def self.parse(args)
    args.push('-h') if args.empty?
    options = {}

    opt_parser = OptionParser.new do |parser|
      parser.banner = "Usage: parser.rb [options]"

      parser.on("-f FROM", Time, "Logs From given time") do |time_from|
        options[:from] = time_from
      end

      parser.on("-t TO", Time, "Logs upto given time") do |time_to|
        options[:to] = time_to
      end

      parser.on("-i", "--required DIRECTORY","Log files directory to search") do |dir|
        options[:directory] = dir
      end

      parser.on("-h","--help","Prints help") do
        puts parser
        exit
      end
    end

    begin
      opt_parser.parse!(args)
    rescue OptionParser::InvalidArgument => e
      STDERR.puts "Invalid value of time parameter -f or -t."
      puts opt_parser.help
      exit 1
    end
    # unless File.directory?(options[:directory])
    #   abort("file directory not found")
    # end
    options
  end
end

  # p Time.parse("2020-07-16T02:30:00.1234Z").iso8601
  # p options[:from].utc.iso8601
