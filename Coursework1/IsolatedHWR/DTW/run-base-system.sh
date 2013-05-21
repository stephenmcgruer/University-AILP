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

  WNUM=13

  for i in 0 1 2 3 4
  do

    # Clean up any stray files.
    rm -f .mod${i}.tmp
    rm -f .mod${i}.out

    # Mod i
    TIMEARR[i]=$( { time ./run-dtw-dist.sh $CLASS $i s0$WNUM > .mod${i}.tmp; } 2>&1 )
    ./cv-ana-test.pl .mod${i}.tmp > .mod${i}.out

    ACCARR[i]=`grep "Total" .mod${i}.out | cut -d " " -f 7`

    let WNUM=WNUM+1

  done

  AVGACC=`echo "scale=2;(${ACCARR[0]}+${ACCARR[1]}+${ACCARR[2]}+${ACCARR[3]}+${ACCARR[4]})/5" | bc`
  AVGTIME=`echo "scale=3;(${TIMEARR[0]}+${TIMEARR[1]}+${TIMEARR[2]}+${TIMEARR[3]}+${TIMEARR[4]})/5" | bc`

  # Calc the standard deviations.
  ACCDEVSUM=0
  TIMEDEVSUM=0
  for i in 0 1 2 3 4 
  do
    # Accuracy
    ACCDEVSQRD=`echo "scale=3;(${ACCARR[i]} - $AVGACC)^2" | bc`
    ACCDEVSUM=`echo "scale=3;($ACCDEVSUM + $ACCDEVSQRD)" | bc`

    # Time
    TIMEDEVSQRD=`echo "scale=5;(${TIMEARR[i]} - $AVGTIME)^2" | bc`
    TIMEDEVSUM=`echo "scale=5;($TIMEDEVSUM + $TIMEDEVSQRD)" | bc`
  done
  ACCDEVSUM=`echo "scale=3;($ACCDEVSUM/4)" | bc`
  TIMEDEVSUM=`echo "scale=5;($TIMEDEVSUM/4)" | bc`
  
  STDDEVACC=`echo "scale=3;sqrt($ACCDEVSUM)" | bc`
  STDDEVTIME=`echo "scale=5;sqrt($TIMEDEVSUM)" | bc`

  # Output:
  echo "${CLASS}:"
  for i in 0 1 2 3 4
  do
    echo "  Mod $i Accuracy: ${ACCARR[i]}%"
    echo "  Mod $i (CPU) Time: ${TIMEARR[i]}s"
  done 
  echo "  Average Accuracy: ${AVGACC}%"
  echo "  Average (CPU) Time: ${AVGTIME}s"
  echo "  Accuracy Std Dev: ${STDDEVACC}"
  echo "  Time Std Dev: ${STDDEVTIME}"
  echo

done

