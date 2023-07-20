# frozen_string_literal: true

COLUMNS = 4

def display_contents(dir)
  contents = modified_contents(dir)
  row = calculate_rows(contents)
  contents_rearranged = rearrange_contents(row, contents)
  display(contents_rearranged)
end

def modified_contents(dir)
  # 隠しファイルを排除
  filtered_contents = Dir.children(dir).sort.reject { |content| File.fnmatch('.*', content) }
  # ファイル名の長さに応じてパディングの度合いを変える
  longest = filtered_contents.max_by(&:length).length
  filtered_contents.map do |content|
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
  if contents_count <= (COLUMNS * 2) - 2
    contents_rearranged.each_with_index do |content, i|
      print content
      puts if i + 1 == (contents_count.to_f / 2).ceil
    end
    puts
  else
    contents_rearranged.each_with_index do |content, i|
      print content
      puts if ((i + 1) % COLUMNS).zero?
    end
  end
end

dir = ARGV[0] || '.'
display_contents(dir)
