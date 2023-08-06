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

  contents = format_file_list(file_names)
  row = calculate_rows(contents)
  contents_rearranged = rearrange_contents(row, contents)
  display(contents_rearranged)
end

def file_names(dir, option)
  file_names = Dir.entries(dir).sort
  file_names = file_names.reverse if option[:r]
  file_names = file_names.reject { |content| File.fnmatch('.*', content) } unless option[:a]
  file_names
end

def format_file_list(file_names)
  # ファイル名の長さに応じてパディングの度合いを変える
  longest = file_names.max_by(&:length).length
  file_names.map do |content|
    "#{content.ljust(longest)}    "
  end
end

def calculate_rows(contents)
  # コンテンツを表示するときに必要な行数の算出
  total_contents = contents.size
  (total_contents.to_f / COLUMNS).ceil
end

def rearrange_contents(row, contents)
  divided_contents = contents.each_slice(row).to_a
  # 指定された順序で表示できるようにコンテンツの並びを変えて新しく配列にしまう
  contents_rearranged = []
  row_count = 0
  col_count = 0
  until col_count >= row
    divided_contents.size.times do
      contents_rearranged << divided_contents[row_count][col_count]
      row_count += 1
    end
    row_count = 0
    col_count += 1
  end
  contents_rearranged
end

def display(contents_rearranged)
  contents_count = contents_rearranged.compact.size
  if contents_count <= COLUMNS
    puts contents_rearranged.join('')
    return
  end
  # 2列表示される場合の計算
  # 2列表示に必要な最大コンテンツ数を算出して、適切な場所で改行する
  contents_rearranged.each_with_index do |content, i|
    print content
    if contents_count <= (COLUMNS * 2) - 2
      puts if i + 1 == (contents_count.to_f / 2).ceil || i + 1 == contents_rearranged.size
    else
      puts if ((i + 1) % COLUMNS).zero?
    end
  end
end

def display_with_information(file_names, dir)
  Dir.chdir(dir)
  inode_values, lstat_mode_values, nlink_counts, file_size, block_counts = file_attributes(file_names)
  print_block_count(block_counts)

  file_names.each do |content|
    lstat_mode = format('%06o', File.lstat(content).mode)
    print_file_type(lstat_mode)
    print_permissions(lstat_mode)
    print_number_of_links(content, nlink_counts)
    print_names(content)
    print_contents_size(content, file_size)
    print_last_accessed_time(content)
    print_content_names(content, lstat_mode_values, inode_values, lstat_mode)
  end
end

def print_block_count(block_counts)
  total_block_count = block_counts.sum
  puts "total #{total_block_count}"
end

def file_attributes(file_names)
  inode_values = {}
  lstat_mode_values = {}
  nlink_counts = []
  file_size = []
  block_counts = []

  file_names.each do |content|
    file_information = File.stat(content)
    inode_values[content] = file_information.ino.to_s
    lstat_mode_values[content] = File.lstat(content).mode.to_s(8)
    nlink_counts << file_information.nlink.to_s
    file_size << file_information.size.to_s
    block_counts << file_information.blocks
  end
  [inode_values, lstat_mode_values, nlink_counts, file_size, block_counts]
end

def print_file_type(lstat_mode)
  file_type = lstat_mode.slice(0, 2)
  print(FILE_TYPE[file_type])
end

def print_permissions(lstat_mode)
  permissions = lstat_mode.slice(-3, 3).chars.to_a
  permissions.each_with_index do |n, i|
    print(PERMISSIONS[n])
    print '  ' if i == 2
  end
end

def print_names(content)
  ids = [File.stat(content).uid, File.stat(content).gid]
  print "#{Etc.getpwuid(ids[0]).name}  #{Etc.getgrgid(ids[1]).name}  "
end

def print_number_of_links(content, nlink_counts)
  biggest_number = nlink_counts.max_by(&:length).length
  print "#{File.stat(content).nlink.to_s.rjust(biggest_number)} "
end

def print_contents_size(content, file_size)
  biggest_number = file_size.max_by(&:length).length
  print "#{File.stat(content).size.to_s.rjust(biggest_number)} "
end

def print_last_accessed_time(content)
  print "#{File.stat(content).mtime.strftime('%_m %_d %H:%M')} "
end

# シンボリックファイルに矢印をつける
def print_content_names(content, lstat_mode_values, inode_values, lstat_mode)
  current_lmode = lstat_mode
  current_inode = File.stat(content).ino.to_s
  matched_inode = inode_values.select { |_file, id| id == current_inode }
  if current_lmode.start_with?('12')
    matched_inode.each do |file, _id|
      puts "#{content} -> #{file}" if !lstat_mode_values[file].start_with?('12')
    end
  else
    puts content
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
