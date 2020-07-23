require_relative 'opt_parser'
require_relative 'log_parser'
require_relative 'utils/helper_methods'

options = OptParser.parse(ARGV)

log_parser = LogParser.new('console')

from_t = HelperMethods.to_utc(options[:from])
to_t = HelperMethods.to_utc(options[:to])
log_parser.logs_in_range(from_t, to_t, options[:directory])



