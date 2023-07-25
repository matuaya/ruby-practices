#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
last_frame = []
shots.each_slice(2).each_with_index do |s, i|
  if i <= 8
    frames << s
  else
    last_frame << s
  end
end

frame10_score = []
last_frame.each do |s|
  frame10_score << if s[0] == 10
                     10
                   else
                     s
                   end
end
frames << frame10_score.flatten

point = 0
frames.each_with_index do |frame, i|
  next_flame = frames[i + 1]
  point += if i < 9
             if i == 8 && frame[0] == 10
               frame.sum + next_flame.take(2).sum
             elsif frame[0] == 10 && next_flame[0] == 10
               frame.sum + 10 + frames[i + 2][0]
             elsif frame[0] == 10
               frame.sum + next_flame.sum
             elsif frame.sum == 10
               frame.sum + next_flame[0]
             else
               frame.sum
             end
           else
             frame.sum
           end
end
puts point
