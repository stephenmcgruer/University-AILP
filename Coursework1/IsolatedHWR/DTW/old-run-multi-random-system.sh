#!/bin/bash

# Use nice time output.
TIMEFORMAT=%S

EVEN="../CV-LISTS/list-cv2-0"
ODD="../CV-LISTS/list-cv2-1"

# Get the even and odd random writers.
RANDEVEN=""
RANDODD=""

COUNTER=0

while [ $COUNTER -lt 8 ];
do
  NUMBER=$((1 + (`od -An -N2 -i /dev/random`) % 159))
  if [ $(($NUMBER % 2)) -ne 0 ]; then
    let NUMBER=NUMBER-1
  fi
  if [ $NUMBER -lt 100 ]; then
    if [ $NUMBER -lt 10 ]; then 
      NUMBER="0$NUMBER"
    fi
    NUMBER="0$NUMBER"
  fi
  RANDEVEN="$RANDEVEN $NUMBER"
  let COUNTER=COUNTER+1
done

COUNTER=0

while [ $COUNTER -lt 8 ];
do
  NUMBER=$((1 + (`od -An -N2 -i /dev/random`) % 159))
  if [ $(($NUMBER % 2)) -ne 1 ]; then
    let NUMBER=NUMBER-1
  fi
  if [ $NUMBER -lt 100 ]; then
    if [ $NUMBER -lt 10 ]; then 
      NUMBER="0$NUMBER"
    fi
    NUMBER="0$NUMBER"
  fi
  RANDODD="$RANDODD $NUMBER"
  let COUNTER=COUNTER+1
done

rm -f .evenwriters.tmp
rm -f .oddwriters.tmp

for NUM in $RANDEVEN;
do
  echo "s$NUM" >> .evenwriters.tmp
done
for NUM in $RANDODD;
do
  echo "s$NUM" >> .oddwriters.tmp
done

for CLASS in Digits Lowercase Uppercase
do

  # Even numbered inputs
  EVENTIME=$( { time ./run-dtw-dist-mt.sh .oddwriters.tmp $EVEN $CLASS | ./mt-knn.pl > .even.tmp; } 2>&1 )
  ./cv-ana-test.pl .even.tmp > .even2.tmp

  # Odd numbered inputs
  ODDTIME=$( { time ./run-dtw-dist-mt.sh .evenwriters.tmp $ODD $CLASS | ./mt-knn.pl > .odd.tmp; } 2>&1 )
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

rm -f .evenwriters.tmp
rm -f .oddwriters.tmp
