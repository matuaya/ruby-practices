# frozen_string_literal: true

require 'etc'

PERMISSIONS = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
                '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

class FileInfo
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def base_name
    File.basename(@file_path)
  end

  def type
    file_lstat = File.lstat(@file_path)
    if file_lstat.directory?
      'd'
    elsif file_lstat.symlink?
      'l'
    else
      '-'
    end
  end

  def mode
    file_stat.mode.to_s(8).slice(-3, 3).chars.to_a.map { |n| PERMISSIONS[n] }.join
  end

  def link_num
    file_stat.nlink
  end

  def size
    file_stat.size
  end

  def user
    Etc.getpwuid(file_stat.uid).name
  end

  def group
    Etc.getgrgid(file_stat.gid).name
  end

  def last_access_time
    file_stat.mtime.strftime('%_m %_d %H:%M')
  end

  def symlink?
    mode_num = File.lstat(@file_path).mode.to_s(8)
    mode_num[0, 2] == '12'
  end

  def blocks
    file_stat.blocks
  end

  def full_info_format(max_lengths)
    "#{type}#{mode}  "\
    "#{link_num.to_s.rjust(max_lengths[:nlink])} "\
    "#{user.rjust(max_lengths[:user])}  #{group.to_s.rjust(max_lengths[:group])}  "\
    "#{size.to_s.rjust(max_lengths[:size])} "\
    "#{last_access_time} #{base_name}"\
    "#{" -> #{File.readlink(file_path)}" if symlink?}"
  end

  private

  def file_stat
    File::Stat.new(@file_path)
  end
end
