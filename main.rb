require_relative 'opt_parser'
require_relative 'log_parser'

options = OptParser.parse(ARGV)
p options
# print_logs(options[:from].utc.iso8601, options[:to].utc.iso8601, options[:directory])
