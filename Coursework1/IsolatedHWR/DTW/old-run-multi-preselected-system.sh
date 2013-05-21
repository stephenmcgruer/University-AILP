#!/bin/bash

# run-multi-preselected-system.sh

# 

# Use nice time output.
TIMEFORMAT=%S

EVEN="../CV-LISTS/list-cv2-0"
ODD="../CV-LISTS/list-cv2-1"

# Get the 'best' even and odd writers.
# If these don't exist, the script will fail horribly.
# (So make sure they do.)
BESTEVEN="../Analysis/Multitemplate/top-8-even"
BESTODD="../Analysis/Multitemplate/top-8-odd"

for CLASS in Digits Lowercase Uppercase
do

  # Even numbered inputs
  EVENTIME=$( { time ./run-dtw-dist-mt.sh $BESTODD $EVEN $CLASS | ./mt-knn.pl > .even.tmp; } 2>&1 )
  ./cv-ana-test.pl .even.tmp > .even2.tmp

  # Odd numbered inputs
  ODDTIME=$( { time ./run-dtw-dist-mt.sh $BESTEVEN $ODD $CLASS | ./mt-knn.pl > .odd.tmp; } 2>&1 )
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
