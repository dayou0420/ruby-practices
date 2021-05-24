# frozen_string_literal: true

require 'optparse'

# With calculating total
def text_lines(file)
  file.lines.count
end

def character_counts(file)
  file.split(/\s+/).size
end

def byte_size(file)
  file.size
end

# Standard input methods
def lines(input)
  input.count("\n").to_s.rjust(8)
end

def characters(input)
  input.split(/\s+/).size.to_s.rjust(8)
end

def byte(input)
  input.size.to_s.rjust(8)
end

target_file = ARGV

params = ARGV.getopts('l')

# Standard output
if File.pipe?($stdin) || target_file.empty?
  input = $stdin.read
  puts "#{lines(input)} #{characters(input)} #{byte(input)}"

# With -l option
elsif params['l']
  lines_sum = 0
  target_file.each do |f|
    file = File.read(f)
    puts "#{file.count("\n").to_s.rjust(8)} #{f}"
    lines_sum += text_lines(file)
  end
  puts "#{lines_sum.to_s.rjust(8)} total" if target_file.size >= 2

# Without option
else
  lines_sum = 0
  characters_sum = 0
  bytes_sum = 0
  target_file.each do |f|
    file = File.read(f)
    puts "#{file.count("\n").to_s.rjust(8)} #{file.split(/\s+/).size.to_s.rjust(8)}"\
         "#{file.size.to_s.rjust(8)} #{f}"
    lines_sum += text_lines(file)
    characters_sum += character_counts(file)
    bytes_sum += byte_size(file)
  end
  puts "#{lines_sum.to_s.rjust(8)} #{characters_sum.to_s.rjust(8)} #{bytes_sum.to_s.rjust(7)} total" if target_file.size >= 2
end
