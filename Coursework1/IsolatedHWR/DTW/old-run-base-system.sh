#!/bin/bash

# run-base-system.sh
#
# Runs the base system for the project, with no normalisation
# or multitemplating.

# Usage: ./run-base-system.sh

# Use nice time output.
TIMEFORMAT=%S

for CLASS in Digits Lowercase Uppercase
do

  # Even numbered
  EVENTIME=$( { time ./old-run-dtw-dist.sh $CLASS 0 s013 > .even.tmp; } 2>&1 )
  ./cv-ana-test.pl .even.tmp > .even2.tmp

  # Odd numbered
  ODDTIME=$( { time ./old-run-dtw-dist.sh $CLASS 1 s014 > .odd.tmp; } 2>&1 )
  ./cv-ana-test.pl .odd.tmp > .odd2.tmp

  EVENACC=`grep "Total" .even2.tmp | cut -d " " -f 7`
  ODDACC=`grep "Total" .odd2.tmp | cut -d " " -f 7`

  AVGACC=`echo "scale=2;($EVENACC+$ODDACC)/2" | bc`
  AVGTIME=`echo "scale=3;($EVENTIME+$ODDTIME)/2" | bc`

  echo "${CLASS}:"
  echo "  Even Accuracy: ${EVENACC}%"
  echo "  Even (CPU) Time: ${EVENTIME}s"
  echo "  Odd Accuracy: ${ODDACC}%"
  echo "  Even (CPU) Time: ${ODDTIME}s"
  echo "  Average Accuracy: ${AVGACC}%"
  echo "  Average (CPU) Time: ${AVGTIME}s"
  echo

  rm -f .even.tmp
  rm -f .odd.tmp
  rm -f .even2.tmp
  rm -f .odd2.tmp
done

