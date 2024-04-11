# frozen_string_literal: true

require_relative 'basic_format'

class LsCommand
  def initialize(path, options)
    @path = path
    @options = options
  end

  def display
    puts formatter.format_lines
  end

  private

  def file_paths
    file_pattern = File.join(@path, '*')
    file_paths = @options[:a] ? Dir.glob(file_pattern, File::FNM_DOTMATCH) : Dir.glob(file_pattern)
    @options[:r] ? file_paths.reverse : file_paths
  end

  def formatter
    BasicFormat.new(file_paths)
  end
end
