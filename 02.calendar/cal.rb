#!/usr/bin/env ruby

require 'date'
require 'optparse'

opt = OptionParser.new

get_date = Date.today

opt.on('-y', '--year VALUE', "year value") do |get_year|
  get_date = Date.new(get_year.to_i, get_date.month)
end

opt.on('-m', '--month VALUE', "month value") do |get_month|
  get_date = Date.new(get_date.year, get_month.to_i)
end

opt.parse!(ARGV)

first_date = Date.new(get_date.year, get_date.month, 1)
last_date = Date.new(get_date.year, get_date.month, -1)

puts "#{get_date.month}月 #{get_date.year}年".center(20)

puts "日 月 火 水 木 金 土"

space = "   " * first_date.wday
print space

week_day = first_date.wday
(1..last_date.day).each do |days|
  print days.to_s.rjust(2) + " "
  week_day = week_day + 1
  if week_day %7 == 0
    print "\n"
  end
end

if week_day %7 != 0
  print "\n"
end

