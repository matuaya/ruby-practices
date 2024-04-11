# frozen_string_literal: true

require_relative 'ls_command'
require 'optparse'

opt = OptionParser.new
options = {}
opt.on('-a') { |v| options[:a] = v }
opt.on('-r') { |v| options[:r] = v }
opt.on('-l') { |v| options[:l] = v }
opt.parse!(ARGV)

path = ARGV[0] || '.'
LsCommand.new(path, options).display
