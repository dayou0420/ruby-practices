# frozen_string_literal: true

require 'optparse'
require 'etc'

params = ARGV.getopts('r', 'l', 'a')

@target_files = if params['a']
                  Dir.glob('*', File::FNM_DOTMATCH).sort
                else
                  Dir.glob('*').sort
                end

def ls_command(target_files)
  max_words = target_files.map(&:length).max.to_i
  files = target_files.map { |file| file.ljust(max_words) }
  files << nil while (files.size % 3) != 0
  allow_size = files.size / 3
  result = files.each_slice(allow_size).to_a.transpose
  result.each { |row| puts row.join(' ') }
end

def file_type(file)
  file = File.stat(file.strip).ftype
  file_type = {
    'directory' => 'd',
    'file' => '-'
  }
  file_type[file]
end

def file_mode(file)
  mode = File.stat(file.strip).mode.to_s(8)
  mode = mode[-3, 3].chars.map { |m| m }

  file = mode.map do |n|
    permission_type = {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }
    permission_type[n]
  end
  file.join
end

def file_hard_link(file)
  hard_link = @target_files.map { |f| File.stat(f.strip).nlink.to_s }
  hard_link_length = hard_link.max_by(&:length).length
  File.stat(file.strip).nlink.to_s.rjust(hard_link_length)
end

def file_byte(file)
  file_byte = @target_files.compact.map { |f| File.stat(f.strip).size.to_s }
  file_byte_length = file_byte.max_by(&:length).length
  File.stat(file.strip).size.to_s.rjust(file_byte_length)
end

def file_time_stamp_month(file)
  file_time_stamp_month = @target_files.compact.map { |f| File.stat(f.strip).mtime.month.to_s }
  file_time_stamp_month_length = file_time_stamp_month.max_by(&:length).length
  File.stat(file.strip).mtime.month.to_s.rjust(file_time_stamp_month_length)
end

def file_time_stamp_day(file)
  file_time_stamp_day = @target_files.compact.map { |f| File.stat(f.strip).mtime.day.to_s }
  file_time_stamp_day_length = file_time_stamp_day.max_by(&:length).length
  File.stat(file.strip).mtime.day.to_s.rjust(file_time_stamp_day_length)
end

def file_time_stamp_time(file)
  file_time_stamp_time = @target_files.compact.map { |f| File.stat(f.strip).mtime.strftime('%H:%M') }
  file_time_stamp_time_length = file_time_stamp_time.max_by(&:length).length
  File.stat(file.strip).mtime.strftime('%H:%M').rjust(file_time_stamp_time_length)
end

def file_owner(file)
  @target_files.compact.map { |f| Etc.getpwuid(File.stat(f.strip).uid).name }
  Etc.getpwuid(File.stat(file.strip).uid).name
end

def file_group(file)
  @target_files.compact.map { |f| Etc.getgrgid(File.stat(f.strip).gid).name }
  Etc.getgrgid(File.stat(file.strip).gid).name
end

# output process

@target_files.reverse! if params['r']

if params['l']
  file_blocks = @target_files.compact.map { |file| File.stat(file.strip).blocks }
  puts "total #{file_blocks.sum}"
  @target_files.compact.each do |file|
    puts "#{file_type(file)}#{file_mode(file)} #{file_hard_link(file)} #{file_owner(file)} #{file_group(file)} #{file_byte(file)}"\
    " #{file_time_stamp_month(file)} #{file_time_stamp_day(file)} #{file_time_stamp_time(file)} #{file}"
  end
else
  ls_command(@target_files)
end
