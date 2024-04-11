# frozen_string_literal: true

require_relative 'ls_command'

path = ARGV[0] || '.'
LsCommand.new(path).display
