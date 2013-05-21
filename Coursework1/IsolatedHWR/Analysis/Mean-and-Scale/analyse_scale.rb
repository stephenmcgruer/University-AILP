#!/usr/bin/env ruby

# analyse_scale.rb

# This program takes an input filename. The file with this
# name should contain a list of writer file names, in the
# format sXXX/sXXXCXX.dat, where X is a digit and C the
# class letter. This script will then read in each of
# these files, compute the size of the bounding box for 
# the character and add this value to a histogram of
# the bounding box sizes. The histogram is then written
# to the file bHisto.dat.
#
# Usage: ruby analyse_scale in_file


if __FILE__ == $0

  unless ARGV.length == 1
    puts "Usage: ruby analyse_scale.rb in_file\n"
    exit
  end

  # The hash that stores the bounding box values.
  bHash = {}

  File.open(ARGV[0]).each { |filepath|

    # Cheap and nasty, but we do know that for this data set
    # there are no points > 9999 or below -9999...
    maxX = -9999
    minX = 9999
    maxY = -9999
    minY = 9999

    # Assume that the file is correctly formatted here.
    # There is no reason for it not to be if the program is being
    # used correctly.
    File.open('/group/teaching/ailp/DB/mit-points/'+filepath.chomp!).each { |line|

      splitstr = line.split(' ')

      unless splitstr.length == 0
        maxX = splitstr[0].to_i if splitstr[0].to_i > maxX
        minX = splitstr[0].to_i if splitstr[0].to_i < minX
        maxY = splitstr[1].to_i if splitstr[1].to_i > maxY
        minY = splitstr[1].to_i if splitstr[1].to_i < minY
      end

    }
    
    diffX = maxX - minX
    diffY = maxY - minY

    bigDiff = ( ([diffX, diffY].max) / 10 ) * 10

    # Add the calculated mean for the file to the hash.
    if bHash.has_key?(bigDiff)
      bHash[bigDiff] += 1
    else
      bHash[bigDiff] = 1
    end

  }

  # Sort and write out the hash into a file that will be read from matlab.

  tKey = ""
  tVal = ""

  bArr = bHash.sort

  bArr.each { |element| 
    tKey += "#{element[0]} "
    tVal += "#{element[1]} "
  }

  File.open('.bHisto.dat','w') { |file|
    file.write(tKey+"\n")
    file.write(tVal+"\n")
  }

end
