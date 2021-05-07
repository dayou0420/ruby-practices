# frozen_string_literal: true

score = ARGV[0]

scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots.push(10)
    shots.push(0)
  else
    shots.push(s.to_i)
  end
end

frames = shots.each_slice(2).to_a { |s| frames.push(s) }

point = shots.sum

frames.each_with_index do |frame, i|
  if frames[i][0] == 10 && frames[i + 1][0] == 10
    point += frames[i + 1][0] + frames[i + 2][0]
  elsif frames[i][0] == 10 && frames[i + 1][0] < 10
    point += frames[i + 1][0] + frames[i + 1][1]
  elsif frame.sum == 10 && frames[i][0] < 10 && i < 9
    point += frames[i + 1][0]
  end
  break if i == 8
end

puts point
