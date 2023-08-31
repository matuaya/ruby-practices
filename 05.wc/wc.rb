# frozen_string_literal: true

require 'optparse'

MINIMUM_WIDTH = 7

def display(option)
  files = ARGV.empty? ? [$stdin.read] : ARGV.map { |file| File.open(file, 'r').read }
  width = calculate_padding(files)

  files.each_with_index do |file, i|
    line_count = line_count(file)
    word_count = word_count(file)
    char_count = char_count(file)

    result = ''
    result += " #{line_count.to_s.rjust(width)}" if option[:l]
    result += " #{word_count.to_s.rjust(width)}" if option[:w]
    result += " #{char_count.to_s.rjust(width)}" if option[:c]
    result = " #{line_count.to_s.rjust(width)} #{word_count.to_s.rjust(width)} #{char_count.to_s.rjust(width)}" if option.empty?
    print result
    puts " #{ARGV[i]}"
  end
  return unless files.length > 1

  # ファイル数が複数ある場合のトータル数表示
  display_total(files, option, width)
end

def display_total(files, option, width)
  line_total = files.map { |file| file.count("\n") }.sum
  word_total = files.map { |file| file.split(' ').count }.sum

  result = ''
  result += " #{line_total.to_s.rjust(width)}" if option[:l]
  result += " #{word_total.to_s.rjust(width)}" if option[:w]
  result += " #{char_total.to_s.rjust(width)}" if option[:c]
  result = " #{line_total.to_s.rjust(width)} #{word_total.to_s.rjust(width)} #{char_total.to_s.rjust(width)}" if option.empty?
  print result
  puts ' total'
end

def calculate_padding(contents)
  width = contents.map { |content| char_count(content) }.sum.to_s.length
  [width, MINIMUM_WIDTH].max
end

def line_count(contents)
  contents.count("\n")
end

def word_count(contents)
  contents.split(' ').count
end

def char_count(contents)
  contents.chars.map(&:bytesize).sum
end

def char_total
  ARGV.map do |file|
    file_contents = File.open(file, 'r').read
    char_count(file_contents)
  end.sum
end

option = {}
opt = OptionParser.new
opt.on('-c', 'c') { |v| option[:c] = v }
opt.on('-w', 'w') { |v| option[:w] = v }
opt.on('-l', 'l') { |v| option[:l] = v }
opt.parse!(ARGV)

display(option)
