#!/bin/bash

# dynamic-recog.sh

# Runs the recognition for the dynamic system, on a set of test and reference
# files.

if [ $# -lt 2 ]; then
  echo "Usage: ./dynamic-recog.sh type ref_file test_file"
  exit 
fi

TYPE=$1
shift

# 2 is the reference file.
REF_FILE=$1
shift

# 3 is the test patterns file
TESTPATTERNS=`cat $1 | tr "\n" " "`
shift

for PATTERN in $TESTPATTERNS
do
  # Oopsie hardcoded oh well.
  PAT=${PATTERN:35:4}
  PATNUM=${PAT:1}

  echo "#>> TEST_FILE=$PATTERN"

  ./dynamic.sh $PATTERN $REF_FILE > .dy-recog.tmp
  if [ $TYPE == "w" ]; then
    ruby conv2labels.rb ../etc/map-lu .dy-recog.tmp > .dy-dic.tmp
    java DictionaryLookup .dy-dic.tmp "../dic/dic-large"
  else
    java DictionaryLookup .dy-recog.tmp "../dic/dic-n"
  fi

done

rm -f ".baseline-writers.tmp"
