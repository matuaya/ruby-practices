# frozen_string_literal: true

class DetailedFormat < BasicFormat
  def format_lines
    @files.map do |file|
      file.full_info_format(max_lengths)
    end
  end

  def calculate_total_blocks
    @files.sum(&:blocks)
  end

  private

  def max_lengths
    max_lengths = {}
    max_lengths[:size] = @files.map { |file| file.size.to_s.length }.max
    max_lengths[:nlink] = @files.map { |file| file.link_num.to_s.length }.max
    max_lengths[:user]  = @files.map { |file| file.user.length }.max
    max_lengths[:group] = @files.map { |file| file.group.length }.max

    max_lengths
  end
end
