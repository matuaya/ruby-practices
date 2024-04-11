# frozen_string_literal: true

class FileInfo
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

  private

  def file_stat
    File::Stat.new(@file_path)
  end
end
