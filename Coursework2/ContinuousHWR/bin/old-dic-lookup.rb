#!/usr/bin/env ruby

require 'jcode'

# Inputs: File with contents of form a b c : 12345, 
#         Dictionary file to use
# 
# Outputs: Word/number which is closest match to input word.

# Multidimensional arr
def mda(width, height) 
  return Array.new(width){ Array.new(height) }
end 

def edit_dist(s, t)

  m = s.length
  n = t.length

  d = mda(m+1,n+1)
  
  # Deletion
  0.upto(m) { |i|
    d[i][0] = i
  }
  0.upto(n) { |j|
    d[0][j] = j
  }

  1.upto(n) { |j|
    1.upto(m) { |i|
      if (s[i,1] == t[j,1])
        d[i][j] = d[i-1][j-1]
      else 
        d[i][j] = [d[i-1][j] + 1, d[i][j-1] + 1, d[i-1][j-1] + 1].min
      end
    }
  }

  return d[m][n]

end

if ARGV.length < 2 
  puts "LOL ERROR"
  exit
end

search_string = ""
end_section = []

File.open(ARGV[0]) { |f| 
  columns = f.readline.split(/\s\s*/);
  end_section = columns.slice!(columns.index(":"), columns.length)
  search_string = columns.join.capitalize
}

closest_distance = 100
closest_word = ""

File.open(ARGV[1]).each { |line| 
  temp_distance = edit_dist(search_string, line)
  if temp_distance < closest_distance
    closest_word = line
    closest_distance = temp_distance
  end
}

out_arr = closest_word.chomp!.split(//).concat(end_section)
print out_arr.join(" ") + "\n"
