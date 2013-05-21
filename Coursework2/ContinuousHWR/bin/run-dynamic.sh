#!/bin/bash

# Run one-stage dynamic algorithm experiments.

TIMEFORMAT=%U

CV_BASE="../CV-LISTS"

for CLASS in n w
do
  for i in 0 1 2 3 4
  do

    rm -f .dy-mod{$i}.tmp
    rm -f .dy-mod{$i}.out

    # Need to generate 8 random writers which are not in the current fold.
    WRITERS=""
    COUNTER=0
    while [ $COUNTER -lt 1 ]; 
    do
      NUMBER=$[ ( $RANDOM % 159 ) + 1]
      if [ $(($NUMBER % 5)) -eq $i ]; then
        continue
      fi
      if [ $NUMBER -lt 100 ]; then
        if [ $NUMBER -lt 10 ]; then
          NUMBER="0$NUMBER"
        fi
        NUMBER="0$NUMBER"
      fi
      WRITERS="$WRITERS s$NUMBER"
      let COUNTER=COUNTER+1
    done

    echo $WRITERS | tr " " "\n" > .dy_refs

    WFILE="$CV_BASE/list-cv5-$i"

    TIMEARR[i]=$( { time ./run-recog.sh $CLASS velocities dynamic-recog.sh .dy_refs $WFILE > .dy-mod${i}.tmp; } 2>&1 )
    ./chwr-ana.pl .dy-mod${i}.tmp > .dy-mod${i}.out

    ACCARR[i]=`grep "WORD" .dy-mod${i}.out | cut -d " " -f 4 | cut -d "=" -f 2`

  done

  # Averages
  AVGACC=`echo "scale=2;(${ACCARR[0]}+${ACCARR[1]}+${ACCARR[2]}+${ACCARR[3]}+${ACCARR[4]})/5" | bc`
  AVGTIME=`echo "scale=2;(${TIMEARR[0]}+${TIMEARR[1]}+${TIMEARR[2]}+${TIMEARR[3]}+${TIMEARR[4]})/5" | bc`

  # Standard Deviations
  ACCDEVSUM=0
  TIMEDEVSUM=0
  for i in 0 1 2 3 4
  do
    # Accuracy
    ACCDEVSQRD=`echo "scale=3;(${ACCARR[i]} - $AVGACC)^2" | bc`
    ACCDEVSUM=`echo "scale=3;($ACCDEVSUM + $ACCDEVSQRD)" | bc`

    # Time
    TIMEDEVSQRD=`echo "scale=3;(${TIMEARR[i]} - $AVGTIME)^2" | bc`
    TIMEDEVSUM=`echo "scale=3;($TIMEDEVSUM + $TIMEDEVSQRD)" | bc`
  done
  ACCDEVSUM=`echo "scale=3;($ACCDEVSUM/4)" | bc`
  TIMEDEVSUM=`echo "scale=3;($TIMEDEVSUM/4)" | bc`

  STDDEVACC=`echo "scale=3;sqrt($ACCDEVSUM)" | bc`
  STDDEVTIME=`echo "scale=3;sqrt($TIMEDEVSUM)" | bc`

  # Average word time.
  #WORDTIME=`echo "scale=5;($AVGTIME/(159*53))" | bc`

  # Output
  echo "$CLASS:"
  for i in 0 1 2 3 4
  do
    echo "  Mod $i Accuracy: ${ACCARR[i]}%"
    echo "  Mod $i (User) Time: ${TIMEARR[i]}s"
  done 
  echo "  Average Accuracy: ${AVGACC}%"
  echo "  Average (User) Time: ${AVGTIME}s"
  #echo "  Average (User) Time Per Word: ${WORDTIME}s"
  echo "  Accuracy Std Dev: ${STDDEVACC}"
  echo "  Time Std Dev: ${STDDEVTIME}"
  echo
done

# Cleanup
rm -f .dy*
