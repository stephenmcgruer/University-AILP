#!/usr/bin/env ruby

# Probably (hopefully?) the only cheap and nasty script
# in here. I apologise for what follows.

require 'ftools'

# Cheap and nasty
n = 10

["digits", "lower", "upper"].each { |charclass|
 
  `rm -f #{charclass}/*`

  # More cheap/nasty
  n = 26 unless charclass == "digits"

  # Cope over 'n' random files to the relevant directory.
  (1..n).each { |i|
    writer = (rand(159)+1).to_s
    character = (rand(n)+1).to_s

    writer = "0#{writer}" if writer.to_i < 100
    writer = "0#{writer}" if writer.to_i < 10
    character = "0#{character}" if character.to_i < 10

    path = "/group/teaching/ailp/DB/mit-points/s#{writer}/s#{writer}#{charclass[0,1]}#{character}.dat"

    File.copy(path,"#{charclass}/#{i}.dat")

  }

}
