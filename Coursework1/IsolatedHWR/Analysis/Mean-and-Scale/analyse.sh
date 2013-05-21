#!/bin/bash

# analyse.sh
#
# Analyses the mit points, computing histograms for their
# mean point and the size of the bounding box required to 
# contain them.
#
# Usage: ./analyse.sh

# Writers directory
DATADIR="/group/teaching/ailp/DB/mit-points"

# A list of all the writers in the above directory.
WDIRS=`ls $DATADIR | tr "\n" " "`

# Delete any left over files.
rm -rf .analyse_digits
rm -rf .analyse_lower
rm -rf .analyse_upper

echo "Creating writer lists..."

# For each writer, append all of their relevant files
# to the digit, lower-case and upper-case analysis
# files.
for WDIR in $WDIRS
do
  TEMPDIR="$DATADIR/$WDIR"
  DIGITFILES=`ls $TEMPDIR | grep 's...d..\.dat'`
  LOWERFILES=`ls $TEMPDIR | grep 's...l..\.dat'`
  UPPERFILES=`ls $TEMPDIR | grep 's...u..\.dat'`

  for DIGITFILE in $DIGITFILES
  do
    echo "$WDIR/$DIGITFILE" >> .analyse_digits
  done

  for LOWERFILE in $LOWERFILES
  do
    echo "$WDIR/$LOWERFILE" >> .analyse_lower
  done

  for UPPERFILE in $UPPERFILES
  do
    echo "$WDIR/$UPPERFILE" >> .analyse_upper
  done

done

echo "Done."
echo

# Run the analysis on each class type.

echo "Analysing digits..."

if [ ! -d "digits" ]; then
  mkdir "digits"
fi

ruby analyse_mean.rb .analyse_digits
matlab -nodisplay -r analyse_mean >> /dev/null
mv xHisto.png digits/mean_xHisto.png
mv yHisto.png digits/mean_yHisto.png

ruby analyse_scale.rb .analyse_digits
matlab -nodisplay -r analyse_scale >> /dev/null
mv bHisto.png digits/scale_bHisto.png

echo "Done."
echo

echo "Analysing lower case letters..."

if [ ! -d "lower" ]; then
  mkdir "lower"
fi

ruby analyse_mean.rb .analyse_lower
matlab -nodisplay -r analyse_mean >> /dev/null
mv xHisto.png lower/mean_xHisto.png
mv yHisto.png lower/mean_yHisto.png

ruby analyse_scale.rb .analyse_lower
matlab -nodisplay -r analyse_scale >> /dev/null
mv bHisto.png lower/scale_bHisto.png

echo "Done."
echo

echo "Analysing upper case letters..."

if [ ! -d "upper" ]; then
  mkdir "upper"
fi

ruby analyse_mean.rb .analyse_upper
matlab -nodisplay -r analyse_mean >> /dev/null
mv xHisto.png upper/mean_xHisto.png
mv yHisto.png upper/mean_yHisto.png

ruby analyse_scale.rb .analyse_upper
matlab -nodisplay -r analyse_scale >> /dev/null
mv bHisto.png upper/scale_bHisto.png

echo "Done."
echo

echo "Cleaning up..."
rm -rf .analyse_digits
rm -rf .analyse_lower
rm -rf .analyse_upper
rm -rf .xHisto.dat
rm -rf .yHisto.dat
rm -rf .bHisto.dat
echo "Done! Bye!"
