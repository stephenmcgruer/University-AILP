#!/bin/bash

# analyse.sh
#
# Analyse the list of writers to find the top num_of_best
# reference patterns for single-template recognition.
#
# Usage: analyse.sh num_of_best

if [ $# -lt 1 ]; then
  echo "Usage: analyse.sh num_of_best"
  exit 1
fi

EVENS=`cat ../../CV-LISTS/list-cv2-0 | tr "\n" " "`
ODDS=`cat ../../CV-LISTS/list-cv2-1 | tr "\n" " "`


# The evens and odds files are expensive to create, so
# only delete them if the recognition algorithm has 
# changed or the source data has changed.
if [ ! -e .evens.tmp ]; then
  rm -f .evens.tmp
  for EVEN in $EVENS;
  do
    cd ../../DTW
    DIGITS=`./run-dtw-dist.sh Digits 1 $EVEN | ./cv-ana-test.pl | grep "Total" | cut -d " " -f 7`
    UPPER=`./run-dtw-dist.sh Uppercase 1 $EVEN | ./cv-ana-test.pl | grep "Total" | cut -d " " -f 7`
    LOWER=`./run-dtw-dist.sh Lowercase 1 $EVEN | ./cv-ana-test.pl | grep "Total" | cut -d " " -f 7`
    AVG=`echo "scale=2;($DIGITS + $UPPER + $LOWER)/3" | bc`
    cd ../Analysis/Multitemplate
    echo $EVEN $AVG >> .evens.tmp
  done
fi

if [ ! -e .odds.tmp ]; then
  rm -f .odds.tmp
  for ODD in $ODDS;
  do
    cd ../../DTW
    DIGITS=`./run-dtw-dist.sh Digits 0 $ODD | ./cv-ana-test.pl | grep "Total" | cut -d " " -f 7`
    UPPER=`./run-dtw-dist.sh Uppercase 0 $ODD | ./cv-ana-test.pl | grep "Total" | cut -d " " -f 7`
    LOWER=`./run-dtw-dist.sh Lowercase 0 $ODD | ./cv-ana-test.pl | grep "Total" | cut -d " " -f 7`
    AVG=`echo "scale=2;($DIGITS + $UPPER + $LOWER)/3" | bc`
    cd ../Analysis/Multitemplate
    echo $ODD $AVG >> .odds.tmp
  done
fi

ruby analyse_file.rb .evens.tmp $1 "top-$1-even"
ruby analyse_file.rb .odds.tmp $1 "top-$1-odd"

# running run-dtw-dist.sh remotely dumps a ref.list file
# into this directory.
rm -f ref.list
