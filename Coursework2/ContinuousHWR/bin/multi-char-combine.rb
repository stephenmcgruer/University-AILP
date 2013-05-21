#!/usr/bin/env ruby

if __FILE__ == $0

  unless ARGV.length == 2
    puts "Usage: ruby multi-char-combine.rb input_file num_references"
    exit
  end

  num_writers = ARGV[1].to_i
  characters = []
  distances = []
  total_dist = 0

  File.open(ARGV[0]).each { |line| 
    if (line.eql? "\n")
      if (distances.length > 0) 
        characters.push distances.clone
        distances.clear
      end
      next
    end
    columns = line.split(/\s/)
    distances.push columns[2]
  }

  characters.each { |dists|
    counter = 0
    min_dist = -1
    min_dists = []

    dists.each { |dist|
      if (counter == 0)
        if (min_dist >= 0)
          min_dists.push min_dist
        end
        min_dist = dist.to_f
      end
      min_dist = dist.to_f if dist.to_f < min_dist
      counter = (counter + 1) % num_writers
    }

    min_dists.push min_dist

    min_dist = min_dists.min
    total_dist += min_dist

    ind = min_dists.index(min_dist).to_s
    print"#{ind} "

  }

  print " : #{total_dist}"
  puts

end
