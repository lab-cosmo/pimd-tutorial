#!/bin/bash

for x in $(ls -p | grep "/" )
do
    #Moves to a sub directory.
    cd $x
    #Extracts number of beads from the directory.
    nP=$(echo $x| cut -d . -f 2| cut -d / -f 1)
    #Calculates gOH.
    cat *pos* | trajworks -box boxfile -gr -gr1 O -gr2 H -grmax 2 -hwin gauss-2 -hwinfac 5  > gOH.data
    cd ..
done

