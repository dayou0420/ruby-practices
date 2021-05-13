# frozen_string_literal: true

require 'optparse'
require 'etc'

params = ARGV.getopts('r', 'l', 'a')

files = if params['a']
          Dir.glob('*', File::FNM_DOTMATCH).sort
        else
          Dir.glob('*').sort
        end

max_words = files.map(&:length).max.to_i
files = files.map { |file| file.ljust(max_words) }

files << nil while (files.size % 3) != 0

allow_size = files.size / 3

result = files.each_slice(allow_size).to_a.transpose

## ls -l description here
if params['r']

  # ls -r command output here
  files.map! { |x| x == nil? ? '' : x }
  files = files.compact.map { |file| file.ljust(max_words) }
  result = files.each_slice(allow_size).to_a.transpose
  result.reverse.map { |row| puts row.reverse.join(' ') }

# ls -l command output here
elsif params['l']
  file_blocks = files.compact.map { |file| File.stat(file.strip).blocks }
  puts "total #{file_blocks.sum}"

  # ls -l file type in description here
  def file_type(file)
    file = File.stat(file.strip).ftype
    case file
    when 'directory'
      'd'
    when 'file'
      '-'
    end
  end

  # ls -l octal digit of permision in descriptin here
  def file_mode(file)
    mode = File.stat(file.strip).mode.to_s(8)
    mode = mode[-3, 3].chars.map { |m| m }

    file = mode.map do |n|
      case n
      when '0' then '---'
      when '1' then '--x'
      when '2' then '-w-'
      when '3' then '-wx'
      when '4' then 'r--'
      when '5' then 'r-x'
      when '6' then 'rw-'
      when '7' then 'rwx'
      end
    end
    file.join
  end

  files.compact.each do |file|
    hard_link = files.compact.map { |f| File.stat(f.strip).nlink.to_s }
    hard_link_length = hard_link.max_by(&:length).length
    hard_link_output = File.stat(file.strip).nlink.to_s.rjust(hard_link_length)

    file_owner = Etc.getpwuid(File.stat(file.strip).uid).name
    file_group = Etc.getgrgid(File.stat(file.strip).gid).name

    file_byte = files.compact.map { |f| File.stat(f.strip).size.to_s }
    file_byte_length = file_byte.max_by(&:length).length
    file_byte_output = File.stat(file.strip).size.to_s.rjust(file_byte_length)

    file_time_stamp_month = files.compact.map { |f| File.stat(f.strip).mtime.month.to_s }
    file_time_stamp_month_length = file_time_stamp_month.max_by(&:length).length
    file_time_stamp_month_output = File.stat(file.strip).mtime.month.to_s.rjust(file_time_stamp_month_length)

    file_time_stamp_day = files.compact.map { |f| File.stat(f.strip).mtime.day.to_s }
    file_time_stamp_day_length = file_time_stamp_day.max_by(&:length).length
    file_time_stamp_day_output = File.stat(file.strip).mtime.day.to_s.rjust(file_time_stamp_day_length)

    file_time_stamp_time = files.compact.map { |f| File.stat(f.strip).mtime.strftime('%H:%M') }
    file_time_stamp_time_length = file_time_stamp_time.max_by(&:length).length
    file_time_stamp_time_output = File.stat(file.strip).mtime.strftime('%H:%M').rjust(file_time_stamp_time_length)

    puts "#{file_type(file)}#{file_mode(file)} #{hard_link_output} #{file_owner} #{file_group} #{file_byte_output}"\
    "#{file_time_stamp_month_output} #{file_time_stamp_day_output} #{file_time_stamp_time_output} #{file}"
  end
else
  # ls command output without option here
  result.each { |row| puts row.join(' ') }
end
