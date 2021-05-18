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

def symbol_type(file)
  file = File.stat(file.strip).ftype
  file_type = {
    'directory' => 'd',
    'file' => '-'
  }
  file_type[file]
end

def permissions(file)
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

def hard_link(file)
  hard_link = @target_files.map { |f| File.stat(f.strip).nlink.to_s }
  hard_link_length = hard_link.max_by(&:length).length
  File.stat(file.strip).nlink.to_s.rjust(hard_link_length)
end

def byte_size(file)
  byte = @target_files.compact.map { |f| File.stat(f.strip).size.to_s }
  byte_length = byte.max_by(&:length).length
  File.stat(file.strip).size.to_s.rjust(byte_length)
end

def time_stamp_month(file)
  time_stamp_m = @target_files.compact.map { |f| File.stat(f.strip).mtime.month.to_s }
  time_stamp_m_length = time_stamp_m.max_by(&:length).length
  File.stat(file.strip).mtime.month.to_s.rjust(time_stamp_m_length)
end

def time_stamp_day(file)
  time_stamp_d = @target_files.compact.map { |f| File.stat(f.strip).mtime.day.to_s }
  time_stamp_d_length = time_stamp_d.max_by(&:length).length
  File.stat(file.strip).mtime.day.to_s.rjust(time_stamp_d_length)
end

def time_stamp_time(file)
  time_stamp_t = @target_files.compact.map { |f| File.stat(f.strip).mtime.strftime('%H:%M') }
  time_stamp_t_length = time_stamp_t.max_by(&:length).length
  File.stat(file.strip).mtime.strftime('%H:%M').rjust(time_stamp_t_length)
end

def owner_name(file)
  @target_files.compact.map { |f| Etc.getpwuid(File.stat(f.strip).uid).name }
  Etc.getpwuid(File.stat(file.strip).uid).name
end

def group_name(file)
  @target_files.compact.map { |f| Etc.getgrgid(File.stat(f.strip).gid).name }
  Etc.getgrgid(File.stat(file.strip).gid).name
end

# output process

@target_files.reverse! if params['r']

if params['l']
  block_size = @target_files.compact.map { |file| File.stat(file.strip).blocks }
  puts "total #{block_size.sum}"
  @target_files.compact.each do |file|
    puts "#{symbol_type(file)}#{permissions(file)} #{hard_link(file)} #{owner_name(file)} #{group_name(file)} #{byte_size(file)}"\
    " #{time_stamp_month(file)} #{time_stamp_day(file)} #{time_stamp_time(file)} #{file}"
  end
else
  ls_command(@target_files)
end
