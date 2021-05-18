# frozen_string_literal: true

require 'optparse'

# `wc.rb file name and some file names` command here
def text_lines(target_file)
  file = File.open(target_file)
  line_counts = 0
  file.each_line { line_counts += 1 }
  file.close
  line_counts.to_s.rjust(8)
end

def character_counts(target_file)
  characters_array = File.read(target_file).split(/\s+/)
  characters_array.size.to_s.rjust(7)
end

def file_byte(target_file)
  file_info = File.stat(target_file)
  file_info.size.to_s.rjust(8)
end

def file_name(target_file)
  Dir.glob(target_file).join
end

# `ls -l | wc.rb` command here
def lines(input)
  input.count("\n").to_s.rjust(8)
end

def characters(input)
  input.split(/\s+/).size.to_s.rjust(8)
end

def byte(input)
  input.size.to_s.rjust(8)
end

# wc.rb -l option
params = ARGV.getopts('l')

if File.pipe?($stdin)
  input = $stdin.read
  puts "#{lines(input)} #{characters(input)} #{byte(input)}"
elsif params['l']
  every_file = Dir.glob('*').sort
  every_file.delete_if do |f|
    FileTest.directory?(f)
  end
  every_file.each do |f|
    file = File.read(f)
    puts "#{file.count("\n").to_s.rjust(8)} #{file.split(/\s+/).size.to_s.rjust(8)}"\
         "#{file.split(/\s+/).size.to_s.rjust(8)} #{f}"
  end
else
  target_file = ARGV
  target_file.each do |f|
    file = File.read(f)
    puts "#{file.count("\n").to_s.rjust(8)} #{file.split(/\s+/).size.to_s.rjust(8)}"\
         "#{file.split(/\s+/).size.to_s.rjust(8)} #{f}"
  end
end
