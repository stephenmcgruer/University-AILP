#!/bin/bash

# run-all.sh

# Runs all of the experiments and outputs the results
# to experiment.test. Takes a LONG time.

rm -f experiment.test

echo "Base System:" >> experiment.test
./run-base-system.sh >> experiment.test
echo >> experiment.test

echo "Mean System:" >> experiment.test
./run-mean-system.sh >> experiment.test
echo >> experiment.test

echo "Scale System:" >> experiment.test
./run-scale-system.sh >> experiment.test
echo >> experiment.test

echo "Slant System:" >> experiment.test
./run-slant-system.sh >> experiment.test
echo >> experiment.test

echo "Smooth System:" >> experiment.test
./run-smooth-system.sh >> experiment.test
echo >> experiment.test

echo "Everything-else MT System:" >> experiment.test
./run-multi-everything-else-system.sh >> experiment.test
echo >> experiment.test

echo "Preselected MT System:" >> experiment.test
./run-multi-preselected-system.sh >> experiment.test
echo >> experiment.test

echo "Random MT System:" >> experiment.test
for i in 1 2 3 4 5 6 7 8 9 10
do
  echo $i >> experiment.test
  ./run-multi-random-system.sh >> experiment.test
  echo >> experiment.test
done
echo >> experiment.test
echo >> experiment.test

echo "Mean and Scale System:" >> experiment.test
./run-mean-scale-system.sh >> experiment.test
echo >> experiment.test

echo "Best System:" >> experiment.test
./run-best-system.sh >> experiment.test
echo >> experiment.test
