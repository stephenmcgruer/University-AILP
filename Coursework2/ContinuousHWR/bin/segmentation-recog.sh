#!/bin/bash

# segmentation-recog.sh
 
# The main recognition script for segmentation. Runs on a list of input patterns
# and references.


if [ $# -lt 4 ]; then
echo "Usage: ./segmentation-recog.sh type ref_file test_file segmentation_method segmentation_type [commands]"
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

# 4 is the segmentation type
SEG_TYPE=$1
shift

# Finally, grab any remaining commands
COMMANDS=""
while (("$#")); do
  COMMANDS="$COMMANDS $1"
  shift
done

for PATTERN in $TESTPATTERNS
do
  # Oopsie hardcoded oh well.
  PAT=${PATTERN:35:4}
  PATNUM=${PAT:1}

  echo "#>> TEST_FILE=$PATTERN"

  ./segmented.sh $PATTERN $REF_FILE $SEG_TYPE $COMMANDS > .ss-recog.tmp
  #./segmentation-helper.sh $REF_FILE $PATTERN $SEG_TYPE $COMMANDS > .stroke-recog.tmp
  ruby multi-char-combine.rb .ss-recog.tmp 8 > .ss-knn.tmp
  if [ $TYPE == "w" ]; then
    ruby conv2labels.rb ../etc/map-lu .ss-knn.tmp > .ss-dic.tmp
    java DictionaryLookup .ss-dic.tmp ../dic/dic-large
  else
    java DictionaryLookup .ss-knn.tmp "../dic/dic-n"
  fi

done

rm -f ".baseline-writers.tmp"
