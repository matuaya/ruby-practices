# frozen_string_literal: true

FILE_TYPE = { '10' => '-', '12' => 'l', '14' => 's', '01' => 'p',
              '02' => 'c', '04' => 'd', '06' => 'b' }.freeze

PERMISSIONS = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
                '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

require 'optparse'
require 'etc'

COLUMNS = 3

def display_contents(dir, option)
  file_names = file_names(dir, option)
  return display_with_information(file_names, dir) if option[:l]

  files = format_file_list(file_names)
  row = calculate_rows(files)
  files_rearranged = rearrange_files(row, files)
  display(files_rearranged)
end

def file_names(dir, option)
  file_names = Dir.entries(dir).sort
  file_names = file_names.reverse if option[:r]
  file_names = file_names.reject { |file_name| File.fnmatch('.*', file_name) } unless option[:a]
  file_names
end

def format_file_list(file_names)
  # ファイル名の長さに応じてパディングの度合いを変える
  longest = file_names.max_by(&:length).length
  file_names.map do |file_name|
    "#{file_name.ljust(longest)}    "
  end
end

def calculate_rows(files)
  # コンテンツを表示するときに必要な行数の算出
  total_files = files.size
  (total_files.to_f / COLUMNS).ceil
end

def rearrange_files(row, files)
  divided_files = files.each_slice(row).to_a
  # 指定された順序で表示できるようにコンテンツの並びを変えて新しく配列にしまう
  files_rearranged = []
  row_count = 0
  col_count = 0
  until col_count >= row
    divided_files.size.times do
      files_rearranged << divided_files[row_count][col_count]
      row_count += 1
    end
    row_count = 0
    col_count += 1
  end
  files_rearranged
end

def display(files_rearranged)
  files_count = files_rearranged.compact.size
  if files_count <= COLUMNS
    puts files_rearranged.join('')
    return
  end
  # 2列表示される場合の計算
  # 2列表示に必要な最大コンテンツ数を算出して、適切な場所で改行する
  files_rearranged.each_with_index do |file, i|
    print file
    if files_count <= (COLUMNS * 2) - 2
      puts if i + 1 == (files_count.to_f / 2).ceil || i + 1 == files_rearranged.size
    else
      puts if ((i + 1) % COLUMNS).zero?
    end
  end
end

def display_with_information(file_names, dir)
  Dir.chdir(dir)
  width_size = calculate_width_file_size(file_names)
  width_nlink = calculate_width_nlink(file_names)
  total_block_count = file_names.sum { |file_name| File.stat(file_name).blocks }
  puts "total #{total_block_count}"

  file_names.each do |file_name|
    lstat_mode = format('%06o', File.lstat(file_name).mode)
    print "#{file_type(lstat_mode)}#{permissions(lstat_mode)}  #{number_of_links(file_name, width_nlink)} "\
          "#{names(file_name)}  #{file_size(file_name, width_size)} #{last_accessed_time(file_name)} "
    puts files_and_symlinks(file_name)
  end
end

def calculate_width_file_size(file_names)
  file_size = []
  file_names.each do |file_name|
    file_size << File.stat(file_name).size.to_s
  end
  file_size.max_by(&:length).length
end

def calculate_width_nlink(file_names)
  nlink_counts = []
  file_names.each do |file_name|
    nlink_counts << File.stat(file_name).nlink.to_s
  end
  nlink_counts.max_by(&:length).length
end

def file_type(lstat_mode)
  file_type = lstat_mode.slice(0, 2)
  FILE_TYPE[file_type]
end

def permissions(lstat_mode)
  permission = ''
  permissions = lstat_mode.slice(-3, 3).chars.to_a
  permissions.each do |n|
    permission += PERMISSIONS[n]
  end
  permission
end

def names(file_name)
  ids = [File.stat(file_name).uid, File.stat(file_name).gid]
  "#{Etc.getpwuid(ids[0]).name}  #{Etc.getgrgid(ids[1]).name}"
end

def number_of_links(file_name, width_nlink)
  File.stat(file_name).nlink.to_s.rjust(width_nlink)
end

def file_size(file_name, width_size)
  File.stat(file_name).size.to_s.rjust(width_size)
end

def last_accessed_time(file_name)
  File.stat(file_name).mtime.strftime('%_m %_d %H:%M')
end

# シンボリックファイルに矢印をつける
def files_and_symlinks(file_name)
  lstat_mode = File.lstat(file_name).mode.to_s(8)
  if lstat_mode.start_with?('12')
    symbolic = File.readlink(file_name)
    "#{file_name} -> #{symbolic}"
  else
    file_name
  end
end

option = {}
opt = OptionParser.new
opt.on('-a') { |v| option[:a] = v }
opt.on('-r') { |v| option[:r] = v }
opt.on('-l') { |v| option[:l] = v }
opt.parse!(ARGV)

dir = ARGV[0] || '.'

display_contents(dir, option)
