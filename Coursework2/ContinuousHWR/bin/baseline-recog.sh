#!/bin/bash

# Baseline-recog doesnt need character references, and instead uses a 
# straight multi-templating match to words.

if [ $# -lt 4 ]; then
  echo "Usage: ./baseline-recog.sh type ref_file test_file cv_fold [commands]"
  exit 
fi

# We ignore the second argument. The third, however, contains a file which
# lists the patterns we want to loop over.
TESTPATTERNS=`cat $3 | tr "\n" " "`

for PATTERN in $TESTPATTERNS
do
  # Oopsie hardcoded oh well.
  PAT=${PATTERN:35:4}
  PATNUM=${PAT:1}

  # Generate 7 random writers that are not in the test writer fold.
  WRITERS=""
  COUNTER=0
  while [ $COUNTER -lt 8 ]; 
  do
    NUMBER=$[ ( $RANDOM % 159 ) + 1]
    if [ $(($NUMBER % 5)) -eq $4 ]; then
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

  rm -f ".baseline-writers.tmp"
  for WRITER in $WRITERS
  do
    echo $WRITER >> ".baseline-writers.tmp"
  done

  echo "#>> TEST_FILE=$PATTERN"
  ./baseline-helper.sh $1 .baseline-writers.tmp $PATTERN > .baseline-recog.tmp
  ruby baseline-knn-combine.rb $1 .baseline-recog.tmp 8 $PAT > .baseline-knn.tmp
  ruby conv2labels.rb /group/teaching/ailp/DB/Annotations/$PAT/${PAT}${1} .baseline-knn.tmp

done

rm -f ".baseline-writers.tmp"
