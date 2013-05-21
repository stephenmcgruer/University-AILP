#!/bin/sh
# base.sh  -  wrapper code for java Base class

export CLASSPATH=../src:../src/hwr:$HOME/AILP/ZhangLe/IsolatedHWR/src:$HOME/AILP/ZhangLe/IsolatedHWR/src/hwr:.
java Base $*
