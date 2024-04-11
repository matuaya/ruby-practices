# frozen_string_literal: true

require_relative 'file_info'

class BasicFormat
  COLUMN_NUM = 3

  def initialize(file_paths)
    @files = file_paths.map { |file_path| FileInfo.new(file_path) }
  end

  def format_lines
    files_grouped_into_lines.map do |line|
      line.map do |file|
        file_name = file.base_name
        file_name.ljust(max_length)
      end.join('      ')
    end
  end

  private

  def files_grouped_into_lines
    total_line_count = (@files.size.to_f / COLUMN_NUM).ceil
    files_sliced = @files.each_slice(total_line_count).to_a

    lines = Array.new(total_line_count) { [] }
    lines.each_with_index do |line, index|
      files_sliced.each do |files|
        line << files[index] if files[index]
      end
    end

    lines
  end

  def max_length
    @files.map { |file| file.base_name.size }.max
  end
end
