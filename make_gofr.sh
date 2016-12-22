#!/bin/bash

### Testing args

function help {

  echo "Bad Usage: wrong number of arguments"
  echo "Usage: basename $0 <atom1> <atom2>"
  echo "<atom1> and <atom2> are the atoms among which bulding the g(r)."
  exit
}


if [[ $# -ne 2 ]]; then
  help
fi

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  help
fi

found='YES'
for at in $1 $2; do
  for f in example.pos_*.xyz; do
    [[ $f == "example.pos_*.xyz" ]] && found='NO'
    awk '{print $1}' $f | grep $at  &> /dev/null || { # A bit approximate but should do his job!
      echo "ERROR: $f files do not contain atom ${at}!"
      echo "STOP"
      exit
    }
  done
done

if [[ $found == 'NO' ]]; then
  echo "ERROR: No files called example.pos_*.xyz found!"
  echo "Probably you are in the wrong directory. "
  echo "Run this script when in a directory containing a simulation output!"
  exit
fi


# Actual commands
for f in example.pos_*.xyz; do
  SKIP=`sed -n 1p $f | awk '{print ($1+2) *100 +1}'` # Read the first line of the xyz and determine the number of lines to skip the first 100 frames
done

grep CELL   <(tail -q -n +$SKIP example.pos_*.xyz) | awk '{printf"%6.3f 0.0 0.0 0.0 %6.3f 0.0 0.0 0.0 %6.3f\n", $3, $4, $5}' > box.dat
tail -q -n +$SKIP example.pos_*.xyz | trajworks -ixyz -box box.dat -gr -gr1 $1 -gr2 $2 -grmax 5 -grbins 250 -hwin triangle -hwinfac 1 > g${1}${2}.dat
