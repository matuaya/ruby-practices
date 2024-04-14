# frozen_string_literal: true

class DetailedFormat < BasicFormat
  def format_lines
    maxes = max_lengths
    @files.map do |file|
      "#{file.type}#{file.mode}  "\
      "#{file.link_num.to_s.rjust(maxes[:nlink])} "\
      "#{file.user.rjust(maxes[:user])}  #{file.group.to_s.rjust(maxes[:group])}  "\
      "#{file.size.to_s.rjust(maxes[:size])} "\
      "#{file.last_access_time} #{file.base_name}"\
      "#{" -> #{File.readlink(file.file_path)}" if file.symlink?}"
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
