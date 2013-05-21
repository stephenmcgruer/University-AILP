#! /bin/sh
# 
# This program runs "RunRecogniton" with either single-templare or
# multiple-template mode.   
#
# Usage:  run-dtw-dist-mt.sh  reference_writer_list  test_writer_list class_name
#   Each list contains writer names such as "s016"
#   Lines begining with "#" in a list are treated as comment lines
#
#  e.g. % ./run-dtw-dist-mt.sh  ./ref-list  ../CV-LISTS/list-cv2-1 d
#
# NOTE:
# (1) To get a confusion matrix and correct recognition rate in 
#  multiple-template mode, i.e. if there is more than one writer in the
#  referent_writer_list, the output of this program should be fed to 
#  "mt-knn.pl" at first, which transforms the input into such a format 
#  that "cv-ana-test.pl" recognises properly. 
#
# by Hiroshi Shimodaira <h.shimodaira@ed.ac.uk> and Zhang Le  20/October/2007
#
# Edited for the AILP project by submitter.

IAM=`basename $0`

#--- check arguments of this program ---
if [ $# -lt 3 ]; then
    echo "Usage: $IAM reference_writer_listfile test_writer_listfile class_name [commands...]" >&2
    exit 2
fi

AILP_HOME="`dirname $0`/../"
RECOG="$AILP_HOME/bin/dtw.sh"

TMP_REF_PATTERNS="./.tmp_ref_list"
TMP_TST_PATTERNS="./.tmp_tst_list"

#>>>>>>>>>(no need to chage)>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#--- digits --
KIND_DIGITS="d01 d02 d03 d04 d05 d06 d07 d08 d09 d10"
#--- uppercase letters ---
KIND_UCASE="u01 u02 u03 u04 u05 u06 u07 u08 u09 u10 u11 u12 u13 u14 u15 u16 u17 u18 u19 u20 u21 u22 u23 u24 u25 u26" 
#--  lowercase letters ---
KIND_LCASE="l01 l02 l03 l04 l05 l06 l07 l08 l09 l10 l11 l12 l13 l14 l15 l16 l17 l18 l19 l20 l21 l22 l23 l24 l25 l26" 
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#---- dataset top directory ---
DATADIR="/group/teaching/ailp/DB/mit-points"

REF_LISTFILE=$1	# (1st argument) list file of writers for reference patterns
shift
TST_LISTFILE=$1 # (2nd argument) list file of writers for test patterns
shift

if [ ! -f ${REF_LISTFILE} ]; then
    echo "(ERROR)  REF_LISTFILE: $REF_LISTFILE does not exist." >&2
    exit 2
fi
if [ ! -f ${TST_LISTFILE} ]; then
    echo "(ERROR)  TST_LISTFILE: $TST_LISTFILE does not exist." >&2
    exit 2
fi

# Obtain the class.
case $1 in
  "Uppercase")
  # --- Upper case letters ---
  CLASSES="${KIND_UCASE}"
  ;;
  "Lowercase")
  # --- Lower case letters ---
  CLASSES="${KIND_LCASE}"
  ;;
  "Digits")
  # --- Digits ---
  CLASSES="${KIND_DIGITS}"
  ;;
  *  )
  echo "Unrecognized class. Class must be one of 'Digits', 'Lowercase' or 'Uppercase'"
  exit 1
  ;;
esac
shift

# --- Flags for the Java code, 'mean' etc ---
COMMANDS=""
while (("$#")); do
  COMMANDS="$COMMANDS $1"
  shift
done

#--- read lists from the files and ignore comment lines ---
REF_WRITERS=`grep -v -e "^#" ${REF_LISTFILE} | tr "\n" " "`
TST_WRITERS=`grep -v -e "^#" ${TST_LISTFILE} | tr "\n" " "`

N_REF_WRITERS=`echo $REF_WRITERS|wc -w| sed "s/[ \t]//g"`
N_TST_WRITERS=`echo $TST_WRITERS|wc -w| sed "s/[ \t]//g"`

echo "# REF_LISTFILE= $REF_LISTFILE"
echo "# N_REF_WRITERS= $N_REF_WRITERS"
echo "# REF_WRITERS= $REF_WRITERS"
echo "# TST_LISTFILE= $TST_LISTFILE"
echo "# N_TST_WRITERS= $N_TST_WRITERS"

NCLASSES=`echo ${CLASSES}|wc -w`
echo "# CLASSES= ${CLASSES}"
echo "# N_CLASSES= ${NCLASSES}"

#------ make a list of reference patterns -----

rm -f $TMP_REF_PATTERNS
for CLASS in $CLASSES; do
    for REFWID in $REF_WRITERS; do
	echo $DATADIR/${REFWID}/${REFWID}${CLASS}.dat >> $TMP_REF_PATTERNS
    done
done
# echo "#>> N_REFERENCES= $N_REFERENCES"
echo "#>> MULTIPAT= $N_REF_WRITERS"

#--------- run recognition on the data of each class  ------
CID=0
for CLASS in $CLASSES
do
  echo "#>> CLASS= $CID"

  rm -f $TMP_TST_PATTERNS
  for WID in $TST_WRITERS; do
      echo $DATADIR/${WID}/${WID}${CLASS}.dat >> $TMP_TST_PATTERNS
  done
  $RECOG $TMP_TST_PATTERNS $TMP_REF_PATTERNS $COMMANDS

  CID=`expr $CID + 1`
done

rm -f $TMP_TST_PATTERNS $TMP_REF_PATTERNS


