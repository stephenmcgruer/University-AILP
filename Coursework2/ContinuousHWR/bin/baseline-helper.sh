#!/bin/bash

# Baseline-helper

# A helper function for baseline-recog. Takes in a list of reference writers,
# generates patterns for them and passes them to base.sh

#--- check arguments of this program ---
if [ $# -lt 3 ]; then
    echo "Usage: ./baseline-helper type reference_writer_listfile test_file_location [commands]" >&2
    exit 2
fi

RECOG="./base.sh"

TMP_REF_PATTERNS=".baseline_tmp_ref_list"
TMP_TST_PATTERNS=".baseline_tmp_tst_list"

KIND_WORDS="w01 w02 w03 w04 w05 w06 w07 w08 w09 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32 w33 w34 w35 w36 w37 w38 w39 w40 w41 w42 w43 w44 w45 w46 w47 w48 w49 w50 w51 w52 w53"
KIND_NUMBERS="n01 n02 n03 n04 n05 n06 n07 n08 n09 n10 n11 n12 n13 n14 n15 n16 n17 n18 n19 n20 n21 n22 n23 n24 n25"

case $1 in
  "w")
    # Words
    CLASSES="${KIND_WORDS}"
    ;;
  "n")
    # Numbers
    CLASSES="${KIND_NUMBERS}"
    ;;
  *  )
    # Default
    echo "ERROR: Unrecognised type. Valid types are 'n' and 'w'."
    exit -1
    ;;
esac
shift

#---- dataset top directory ---
DATADIR="/group/teaching/ailp/DB/mit-points"

REF_LISTFILE=$1	# (2nd argument) list file of writers for reference patterns
shift
TST_FILE=$1 # (3rd argument) list file of word to classify
shift

if [ ! -f ${REF_LISTFILE} ]; then
    echo "(ERROR)  REF_LISTFILE: $REF_LISTFILE does not exist." >&2
    exit
fi
if [ ! -f ${TST_LISTFILE} ]; then
    echo "(ERROR)  TST_LISTFILE: $TST_LISTFILE does not exist." >&2
    exit
fi


# --- Flags for the Java code, 'mean' etc ---
COMMANDS=""
while (("$#")); do
  COMMANDS="$COMMANDS $1"
  shift
done

#--- read lists from the files and ignore comment lines ---
REF_WRITERS=`grep -v -e "^#" ${REF_LISTFILE} | tr "\n" " "`

N_REF_WRITERS=`echo $REF_WRITERS|wc -w| sed "s/[ \t]//g"`

#------ make a list of reference patterns -----

rm -f $TMP_REF_PATTERNS
for CLASS in $CLASSES; do
    for REFWID in $REF_WRITERS; do
	    echo $DATADIR/${REFWID}/${REFWID}${CLASS}.dat >> $TMP_REF_PATTERNS
    done
done

rm -f $TMP_TST_PATTERNS
echo $TST_FILE > $TMP_TST_PATTERNS

#--------- run recognition on the data ---
$RECOG $TMP_TST_PATTERNS $TMP_REF_PATTERNS $COMMANDS

rm -f $TMP_TST_PATTERNS $TMP_REF_PATTERNS
