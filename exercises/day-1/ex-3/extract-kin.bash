#!/bin/bash

mlag=$1

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
else
        echo "#nbeads avg error"
	for x in $(ls -p | grep "/" )
	do
    	#Moves to a sub directory.
    	cd $x
    	#Extracts number of beads from the directory.
    	nP=$(echo $x| cut -d . -f 2| cut -d / -f 1)
    	#Calculates thekinetic energy energy.
    	grep -v "#" *out| awk '{print $4+$5}'| autocorr -maxlag $mlag | head | awk -v P=$nP '/mean:/ {printf "%5d %15e %15e\n",P,$3,$5}' | sed -e "s/nan/0./g"
    	cd ..
	done
fi
