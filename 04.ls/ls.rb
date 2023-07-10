# frozen_string_literal: true

def display_contents(dir = '.')
  contents = modified_contents(dir)
  row_count = calculate_rows(contents)
  divided_contents = slice_contents(contents, row_count)
  position(row_count, divided_contents)
end

def modified_contents(dir)
  # 隠しファイルを排除して、コンテンツを左揃えにするためにパディング
  filtered_contents = Dir.children(dir).sort.reject { |content| File.fnmatch('.*', content) }
  filtered_contents.map do |content|
    content.ljust(16)
  end
end

def calculate_rows(contents)
  # コンテンツを表示するときに必要な行数の算出
  total_contents = contents.size
  row_count = 4
  if total_contents <= 12
    row_count
  else
    (total_contents.to_f / 3).ceil
  end
end

def slice_contents(contents, row_count)
  divided_contents = []
  contents.each_slice(row_count) do |content|
    divided_contents << content
  end
  # 次のプロセスに必要な配列の数が足りていない場合追加格納する
  min_required_arrays = 3
  (min_required_arrays - divided_contents.size).times do
    divided_contents << []
  end
  divided_contents
end

# グリッドを利用してコンテンツの場所を入れ替える
def position(row_count, divided_contents)
  grid = Array.new(row_count) { Array.new(3, '') }
  grid.each_with_index do |row, row_i|
    row.each_with_index do |_col, col_i|
      grid[row_i][col_i] = divided_contents[col_i][row_i]
    end
  end
  grid.each do |row|
    puts row.join('')
  end
end

dir = ARGV[0] || '.'
display_contents(dir)
