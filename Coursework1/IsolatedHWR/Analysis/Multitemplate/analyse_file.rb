#!/usr/bin/env ruby

# analyse_file.rb

# Takes in an input file of writer names
# and percentages, and outputs the top
# X writers based on the percentages.
#
# Usage: ruby analyse_file.rb in_file num_max out_file 

if __FILE__ == $0

  unless ARGV.length == 3
    puts "Usage: ruby analyse_file.rb in_file num_max out_file"
    exit
  end

  pairArr = []

  File.open(ARGV[0]).each { |pair|

    writer = pair.split(' ')[0]
    accuracy = pair.split(' ')[1]

    pairArr.push([writer,accuracy])

  }

  pairArr.sort! { |a,b| b[1] <=> a[1] }

  # Slice the array to delete all entries apart from the top
  # num_max.
  pairArr.slice!(ARGV[1].to_i,pairArr.length)

  File.open(ARGV[2], 'w') { |file|
    pairArr.each { |element|
      file.write "#{element[0]}\n"
    }
  }

end
