#!/usr/bin/env ruby

# analyse_mean.rb

# This program takes an input filename. The file with this
# name should contain a list of writer file names, in the
# format sXXX/sXXXCXX.dat, where X is a digit and C the
# class letter. This script will then read in each of
# these files, compute the mean for the file, and add
# the x and y coordinates of the mean to histograms
# of the mean points. These histograms are then written
# to the files xHisto.dat and yHisto.dat.
#
# Usage: ruby analyse_mean.rb in_file


if __FILE__ == $0

  unless ARGV.length == 1
    puts "Usage: ruby analyse_mean.rb in_file\n"
    exit
  end

  # The hashes that store the mean x and y values.
  xHash = {}
  yHash = {}

  File.open(ARGV[0]).each { |filepath|

    numberPoints = 0
    sumX = 0
    sumY = 0

    # Assume that the file is correctly formatted here.
    # There is no reason for it not to be if the program is being
    # used correctly.
    File.open('/group/teaching/ailp/DB/mit-points/'+filepath.chomp!).each { |line|

      splitstr = line.split(' ')
      sumX += splitstr[0].to_i
      sumY += splitstr[1].to_i
      numberPoints += 1

    }

    meanX = ((sumX / numberPoints) / 10) * 10
    meanY = ((sumY / numberPoints) / 10) * 10
     
    # Add the calculated means for the file to the hashes.
    if xHash.has_key?(meanX)
      xHash[meanX] += 1
    else
      xHash[meanX] = 1
    end

    if yHash.has_key?(meanY)
      yHash[meanY] += 1
    else
      yHash[meanY] = 1
    end

  }

  # Sort and write out the hashes into a file that will be read from matlab.
  
  tKey = ""
  tVal = ""

  xArr = xHash.sort
  yArr = yHash.sort

  xArr.each { |element|
    tKey += "#{element[0]} "
    tVal += "#{element[1]} "
  }
  
  File.open('.xHisto.dat','w') { |file|
    file.write(tKey+"\n")
    file.write(tVal+"\n")
  }

  tKey = ""
  tVal = ""

  yArr.each { |element|
    tKey += "#{element[0]} "
    tVal += "#{element[1]} "
  }

  File.open('.yHisto.dat','w') { |file|
    file.write(tKey+"\n")
    file.write(tVal+"\n")
  }

end
