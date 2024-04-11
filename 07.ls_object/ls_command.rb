# frozen_string_literal: true

require_relative 'basic_format'

class LsCommand
  def initialize(path)
    @path = path
  end

  def display
    puts formatter.format_lines
  end

  private

  def file_paths
    file_pattern = File.join(@path, '*')
    Dir.glob(file_pattern)
  end

  def formatter
    BasicFormat.new(file_paths)
  end
end
