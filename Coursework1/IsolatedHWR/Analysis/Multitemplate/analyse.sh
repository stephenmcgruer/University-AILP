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

for i in 0 1 2 3 4
do
  echo $i
  # Creating these files are expensive, so only create them if they dont already exist.
  if [ ! -e .not${i}.tmp ]; then
    NOTMODI=`cat ../../CV-LISTS/not-cv5-$i | tr "\n" " "`
    for NOTMOD in $NOTMODI
    do
      cd ../../DTW
      DIGITS=`./run-dtw-dist-5.sh Digits $i $NOTMOD | ./cv-ana-test.pl | grep "Total" | cut -d " " -f 7`
      UPPER=`./run-dtw-dist-5.sh Uppercase $i $NOTMOD | ./cv-ana-test.pl | grep "Total" | cut -d " " -f 7`
      LOWER=`./run-dtw-dist-5.sh Lowercase $i $NOTMOD | ./cv-ana-test.pl | grep "Total" | cut -d " " -f 7`
      AVG=`echo "scale=2;($DIGITS + $UPPER + $LOWER)/3" | bc`
      cd ../Analysis/Multitemplate
      echo $NOTMOD $AVG >> .not${i}.tmp
    done
  fi

  ruby analyse_file.rb .not${i}.tmp $1 "top-$1-not$i"

  # running run-dtw-dist.sh remotely dumps a ref.list file
  # into this directory.
  rm -f ref.list

done
