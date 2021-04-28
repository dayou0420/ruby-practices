#!/usr/bin/env ruby

require 'date'
require 'optparse'

opt = OptionParser.new

target_date = Date.today

opt.on('-y', '--year VALUE', "year value") do |y|
  target_date = Date.new(y.to_i, target_date.month)
end

opt.on('-m', '--month VALUE', "month value") do |m|
  target_date = Date.new(target_date.year, m.to_i)
end

opt.parse!(ARGV)

first_date = Date.new(target_date.year, target_date.month, 1)
last_date = Date.new(target_date.year, target_date.month, -1)

puts "#{target_date.month}月 #{target_date.year}年".center(20)

puts "日 月 火 水 木 金 土"

print "   " * first_date.wday

week_day = first_date.wday
(1..last_date.day).each do |day|
  print day.to_s.rjust(2) + " "
  week_day = week_day + 1
  if week_day %7 == 0
    print "\n"
  end
end

if week_day %7 != 0
  print "\n"
end

