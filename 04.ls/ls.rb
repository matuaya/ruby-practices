# frozen_string_literal: true

require 'optparse'

COLUMNS = 3

def display_contents(dir, option)
  original_contents = modified_contents(dir, option)
  contents = align_padded_contents(original_contents, option)
  row = calculate_rows(contents)
  contents_rearranged = rearrange_contents(row, contents)
  display(contents_rearranged)
end

def modified_contents(dir, option)
  if option[:a]
    Dir.entries(dir).sort
  else
    # 隠しファイルを排除
    Dir.children(dir).sort.reject { |content| File.fnmatch('.*', content) }
  end
end

def align_padded_contents(original_contents, option)
  # ファイル名の長さに応じてパディングの度合いを変える
  longest = original_contents.max_by(&:length).length
  if option [:r]
    original_contents.reverse.map do |content|
      "#{content.ljust(longest)}    "
    end
  else
    original_contents.map do |content|
      "#{content.ljust(longest)}    "
    end
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

option = {}
opt = OptionParser.new
opt.on('-a') { |v| option[:a] = v }
opt.on('-r') { |v| option[:r] = v }
opt.parse!(ARGV)

dir = ARGV[0] || '.'

display_contents(dir, option)
