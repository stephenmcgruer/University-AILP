#!/bin/sh

# examples.sh
#
# Creates examples of applying the different normalisation techniques
# to an example character.
#
# Usage: ./examples.sh

export CLASSPATH=../src:../src/hwr:$HOME/AILP/ZhangLe/IsolatedHWR/src:$HOME/AILP/ZhangLe/IsolatedHWR/src/hwr:.
java MeanExample data/baseExample.dat > data/meanExample.dat
java ScaleExample data/meanExample.dat > data/scaleExample.dat
java SlantExample data/scaleExample.dat > data/slantExample.dat
java SmoothExample data/slantExample.dat > data/smoothExample.dat
