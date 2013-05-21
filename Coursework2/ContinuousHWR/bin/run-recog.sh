#! /bin/sh
# 
# This is just a sample script to run your continuous-HWR program
#
# by Hiroshi Shimodaira <h.shimodaira@ed.ac.uk>  20/October/2007
#
# Modified by coursework submitter.

# Usage: ./run-recog.sh type recog_to_call ref_file tst_file [commands]

#--- check arguments of this program ---
if [ $# -lt 5 ]; then
    echo "Usage: ./run-recog input_type points_or_velocities recog_script reference_listfile  test_listfile [commands...]" >&2
    exit 2
fi

TMP_REF_PATTERNS="./.tmp_ref_list"
TMP_TST_PATTERNS="./.tmp_tst_list"

#>>>>>>>>>(no need to chage)>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#--- digits --
KIND_DIGITS="d01 d02 d03 d04 d05 d06 d07 d08 d09 d10"
#--- uppercase letters ---
KIND_UCASE="u01 u02 u03 u04 u05 u06 u07 u08 u09 u10 u11 u12 u13 u14 u15 u16 u17 u18 u19 u20 u21 u22 u23 u24 u25 u26" 
#--  lowercase letters ---
KIND_LCASE="l01 l02 l03 l04 l05 l06 l07 l08 l09 l10 l11 l12 l13 l14 l15 l16 l17 l18 l19 l20 l21 l22 l23 l24 l25 l26" 
#--- numbers ---
KIND_NUMBERS="n01 n02 n03 n04 n05 n06 n07 n08 n09 n10 n11 n12 n13 n14 n15 n16 n17 n18 n19 n20 n21 n22 n23 n24 n25"
#--- numbers ---
KIND_WORDS="w01 w02 w03 w04 w05 w06 w07 w08 w09 w10"
KIND_WORDS="${KIND_WORDS} w11 w12 w13 w14 w15 w16 w17 w18 w19 w20"
KIND_WORDS="${KIND_WORDS} w21 w22 w23 w24 w25 w26 w27 w28 w29 w30"
KIND_WORDS="${KIND_WORDS} w31 w32 w33 w34 w35 w36 w37 w38 w39 w40"
KIND_WORDS="${KIND_WORDS} w41 w42 w43 w44 w45 w46 w47 w48 w49 w50"
KIND_WORDS="${KIND_WORDS} w51 w52 w53"
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#**** Define reference classes, i.e. characters for reference patterns ****
case $1 in
  "w")
    # Words
    REF_CLASSES="${KIND_LCASE} ${KIND_UCASE}"
    CLASSES="${KIND_WORDS}"
    ;;
  "n")
    # Numbers
    REF_CLASSES="${KIND_DIGITS}"
    CLASSES="${KIND_NUMBERS}"
    ;;
  *  )
    # default
    echo "ERROR: Input type not recognised. Valid input types are 'w' and 'n'"
    exit -1
    ;;
esac
TYPE=$1
shift

#---- dataset top directory ---
DTOP="/group/teaching/ailp/DB"
#--- dataset directory -------
DATADIR="$DTOP/mit-$1"
shift


RECOG="./$1" # (1st argument) recog program to call
shift
REF_LISTFILE=$1	# (2nd argument) list file of writers for reference patterns
shift
TST_LISTFILE=$1 # (3rd argument) list file of writers for test patterns
shift

# Other commands to pass to the recogniser.
COMMANDS=""
while (("$#")); do
  COMMANDS="$COMMANDS $1"
  shift
done

# Check that the reference and test files exist.
if [ ! -f ${REF_LISTFILE} ]; then
    echo "(ERROR)  REF_LISTFILE: $REF_LISTFILE does not eisit." >&2
    exit 2
fi
if [ ! -f ${TST_LISTFILE} ]; then
    echo "(ERROR)  TST_LISTFILE: $TST_LISTFILE does not eisit." >&2
    exit 2
fi

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
echo "# REF_CLASSES= ${REF_CLASSES}"
echo "# CLASSES= ${CLASSES}"
echo "# N_CLASSES= ${NCLASSES}"

echo "# DATADIR= ${DATADIR}"
#------ make a list of reference patterns -----

rm -f $TMP_REF_PATTERNS
for CLASS in $REF_CLASSES; do
    for REFWID in $REF_WRITERS; do
	echo $DATADIR/${REFWID}/${REFWID}${CLASS}.dat >> $TMP_REF_PATTERNS
    done
done

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
  $RECOG $TYPE $TMP_REF_PATTERNS $TMP_TST_PATTERNS $COMMANDS

  CID=`expr $CID + 1`
done

rm -f $TMP_TST_PATTERNS $TMP_REF_PATTERNS
