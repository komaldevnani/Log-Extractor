require_relative 'opt_parser'
require_relative 'log_parser'
require_relative 'helper_methods'

options = OptParser.parse(ARGV)
log_parser = LogParser.new('console')

from_t = options[:from].utc
to_t = options[:to].utc
log_parser.logs_in_range(from_t, to_t, options[:directory])



