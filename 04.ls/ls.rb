# frozen_string_literal: true

def display_contents(dir)
  contents = modified_contents(dir)
  rows = calculate_rows(contents)
  divided_contents = slice_contents(rows, contents)
  contents_rearranged = rearrange_contents(rows, divided_contents)
  display(contents_rearranged)
end

def modified_contents(dir)
  # 隠しファイルを排除
  filtered_contents = Dir.children(dir).sort.reject { |content| File.fnmatch('.*', content) }
  # ファイル名の長さに応じてパディングの度合いを変える
  longest_name = filtered_contents.max_by(&:length)
  name_count = longest_name.length
  if name_count >= 16
    filtered_contents.map do |content|
      "#{content.ljust(name_count)}    "
    end
  else
    filtered_contents.map do |content|
      content.ljust(16).to_s
    end
  end
end

def calculate_rows(contents)
  # コンテンツを表示するときに必要な行数の算出
  total_contents = contents.size
  (total_contents.to_f / 3).ceil
end

def slice_contents(rows, contents)
  divided_contents = []
  contents.each_slice(rows) do |content|
    divided_contents << content
  end
  divided_contents
end

def rearrange_contents(rows, divided_contents)
  # 指定された順序で表示できるようにコンテンツの並びを変えて新しく配列にしまう
  contents_rearranged = []
  row_count = 0
  col_count = 0
  until col_count >= rows
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
  contents_rearranged.each_with_index do |content, i|
    print content
    if contents_rearranged.size == 4
      puts if (i + 1).even?
    elsif ((i + 1) % 3).zero?
      puts
    end
  end
  puts
end

dir = ARGV[0] || '.'
display_contents(dir)
