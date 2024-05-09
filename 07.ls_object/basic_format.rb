# frozen_string_literal: true

require_relative 'file_info'

class BasicFormat
  def initialize(file_paths)
    @files = file_paths.map { |file_path| FileInfo.new(file_path) }
  end

  def format_lines
    NotImplementedError
  end
end
