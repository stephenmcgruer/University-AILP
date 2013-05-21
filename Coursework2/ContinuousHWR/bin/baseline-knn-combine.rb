#!/usr/bin/env ruby

# Combines the distances for multiple references to a single
# one, and finds the closest reference index.

if __FILE__ == $0 

  if ARGV.length < 4
    puts "Usage: ruby mt-combine-knn.rb type input_file num_references writer_name"
    exit
  end

  num_writers = ARGV[2].to_i
  counter = 0
  i = -1
  distances = []

  File.open(ARGV[1]).each { |line|
    columns = line.split(/\s/)
    break if columns.length < 3
    distance = columns[2].to_f
    if counter == 0
      distances.push distance
      i += 1
    else
      distances[i] = distance if distance < distances[i]
    end
    counter = (counter + 1) % num_writers;

  }

  mini = distances.min
  # +1 to convert from 0-52 to 1-53
  ind = (distances.index(mini) + 1).to_s
  ind = "0" + ind unless ind.to_i >= 10
  puts "#{ARGV[3]}#{ARGV[0]}#{ind} : #{mini}"

end
