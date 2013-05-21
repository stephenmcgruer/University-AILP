#!/usr/bin/env ruby

# Oh look, its conv2labels done properly

# Using a map file, converts a row of indexes to a row of labels. The map file
# can either be a multi-column entry where each line is an index followed by a
# label (tab seperated) followed by whatever crap you like (aka an Annotations
# file), or a single-column entry where the row number (starting from 0) will be
# taken as the index (aka an /etc/map- file).

# There is no default map file. One must be provided.
if __FILE__ == $0

  unless ARGV.length == 2
    puts "Usage: ruby conv2labels.rb map_file input_file\n"
    exit
  end

  # Get the map file into a hash.
  # Mode 1 means single columns entry, mode 0 means multicolumn.
  # Index only used in mode 1.
  map = {}
  mode = 0
  index = 0
  File.open(ARGV[0]).each { |line|
    columns = line.split(/\s/)
    mode = 1 unless columns.length > 1 
  }
  
  File.open(ARGV[0]).each { |line|
    columns = line.split(/\s/)
    if mode == 0
      map[columns[0]] = columns[1]
    else
      map[index] = columns[0]
      index += 1
    end
  }

  # For each line in the input file, split over whitespace, then translate
  # everything before a ":" and ignore everything after it.
  File.open(ARGV[1]).each { |line|
    if line.index('#') == 0
      next
    end
    indices = line.split(/\s\s*/)
    i = 0
    while i < indices.length && indices[i] != ":"
      if mode == 1
        print "#{map[indices[i].to_i]} "
      else
        print "#{map[indices[i]]} "
      end
      i += 1
    end
    if i < indices.length
      while i < indices.length
        print "#{indices[i]} "
        i += 1
      end
    end
    print "\n"
  }

end
