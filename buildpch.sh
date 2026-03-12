#/usr/bin/env bash

for prg in iostream format print; do
    echo -n "building $prg.h.gch: ";
    (time -p g++-14 --std=c++23 -x c++-header $prg.h) 2>&1 | egrep real | awk '{print $2}'
done
