#!/usr/bin/env ruby

require 'date'
require 'optparse'

opt = OptionParser.new

dates = Date.today

opt.on('-y', '--year VALUE', "year value") do |y|
  dates = Date.new(y.to_i, dates.month)
end

opt.on('-m', '--month VALUE', "month value") do |m|
  dates = Date.new(dates.year, m.to_i)
end

opt.parse!(ARGV)

first_date = Date.new(dates.year, dates.month, 1)
last_date = Date.new(dates.year, dates.month, -1)

puts "#{dates.month}月 #{dates.year}年".center(20)

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

