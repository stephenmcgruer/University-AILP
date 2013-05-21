#! /bin/sh

# run-dtw-dist.sh

# Runs the recognition algorithm based on a 
# number of input parameters including the
# class (uppercase, lowercase, digits), the
# input-patterns to test (0 to 5), the reference
# pattern to use (i.e. s001) and any normalisation
# commands to be passed to the Java code ('mean', 'scale', etc.)

# Usage: ./run-dtw-dist.sh input_pattern reference_writer [commands]

# --- Location of the recognition algorithm shell file ---
RECOG="./dtw.sh"

# Obtain the class.
case $1 in
  "Uppercase")
    # --- Upper case letters ---
    KIND="u"
    NCLASSES=26
    ;;
  "Lowercase")
    # --- Lower case letters ---
    KIND="l"
    NCLASSES=26
    ;;
  "Digits")
    # --- Digits ---
    KIND="d"
    NCLASSES=10
    ;;
  *  )
    echo "Unrecognized class. Class must be one of 'Digits', 'Lowercase' or 'Uppercase'"
    exit 1
    ;;
esac
shift

# --- Writer directory ---
DATADIR="/group/teaching/ailp/DB/mit-points"

# Get the input files.
LISTFILES="../CV-LISTS/list-cv5-$1"
shift

# Get the reference pattern.
REFDIR="${DATADIR}/$1"
shift

# --- List of input writer IDs ---
WIDS=`cat ${LISTFILES} | tr "\n" " "`

# --- Number of input writers ---
NWRITERS=`echo $WIDS|wc -w| sed "s/[ \t]//g"`

# --- Flags for the Java code, 'mean' etc ---
COMMANDS=""
while (("$#")); do
  COMMANDS="$COMMANDS $1"
  shift
done

# These lines are used by cv-ana-test.pl to process the output.
echo "# REFDIR= $REFDIR"
echo "# NWRITERS= $NWRITERS"

# Build a list of the classes used - i.e. d01 d02 ... d10
N=1
while [ $N -le "$NCLASSES" ]
do
  S=`printf "%02d" $N`
  CLASSES="$CLASSES ${KIND}$S"
  N=`expr $N + 1`
done

# Used by cv-ana-test.pl to process the output.
echo "# CLASSES= $CLASSES"

# Run the DTW algorithm for each input class.
CID=0
for CLASS in $CLASSES
do
  echo "#>> CLASS= $CID"

  # Clean up the input list file from the last loop.
  rm -f input.list

  # Create an input list of each writer for the current class.
  for WID in $WIDS
  do
    echo $DATADIR/${WID}/${WID}${CLASS}.dat >> input.list
  done

  # Clean up the reference list file from the last loop.
  rm -f ref.list

  # Create a reference list of every class file for the chosen
  # reference writer.
  for f in `ls $REFDIR/s???${KIND}??.dat`; do
    echo $f >> ref.list
  done

  # Run the DTW algorithm for each input writer and the current class.
  $RECOG input.list ref.list $COMMANDS

  CID=`expr $CID + 1`

done

# Clean up the stray input and reference lists.
rm -f input.list ref.list


