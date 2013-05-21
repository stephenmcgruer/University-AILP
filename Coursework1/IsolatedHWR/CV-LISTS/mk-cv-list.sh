#! /bin/sh
#  Make lists of writers for k-fold cross validation
#
# Usage:  [-k number_of_folds] the_remainder
#  e.g.  mk-cv-list.sh -k 2 0
#	 mk-cv-list.sh -k 2 1

KFOLD=5		# number of k
WID_END=159

while [ "x$1" != "x" ]
do
  case "$1" in
      -k) KFOLD=$2; shift;;
      -*) echo "unknowin option: $1"; exit 2;;
      *) break;
  esac
  shift
done

for WID_BEGIN
do
  WID="${WID_BEGIN}"
  while [ $WID -le 0 ]
  do
      WID=`expr $WID + $KFOLD`
  done

  while [ $WID -le ${WID_END} ]
  do
    S=`printf "%03d" $WID`
    echo "s$S"
    WID=`expr $WID + $KFOLD`
  done
  
done


