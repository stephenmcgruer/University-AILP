#!/bin/bash

echo "Running baseline..."
./run-baseline.sh > out_baseline

echo "Running stroke segmented"
./run-segmented-stroke.sh > out_segmented_stroke

echo "Running stroke com segmented"
./run-segmented-com.sh > out_segmented_com

echo "Running histo segmented"
./run-segmented-histo.sh > out_segmented_histo

echo "Running soft histo segmented"
./run-soft-segmented-histo.sh > out_soft_segmented_histo

echo "Running one-stage dynamic algorithm"
./run-dynamic.sh > out_dynamic
