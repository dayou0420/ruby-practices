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

(0..8).each do |n|
  if frames[n][0] == 10 && frames[n + 1][0] == 10
    point += frames[n + 1][0] + frames[n + 2][0]
  elsif frames[n][0] == 10
    point += frames[n + 1][0] + frames[n + 1][1]
  elsif frames[n][0] + frames[n][1] == 10
    point += frames[n + 1][0]
  end
end

puts point
