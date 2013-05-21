#!/usr/bin/env ruby

f = File.open("not-cv5-#{ARGV[0]}",'w')

File.open('list-all','r').each { |line|
  f.write(line) if(line.split("s")[1].to_i % 5 != ARGV[0].to_i)
}
