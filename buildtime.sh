#/usr/bin/env bash

if [[ "$1" == "--pch" ]]
then
    ./buildpch.sh
else
    rm -f *.gch
fi

mkdir -p build

for prg in puts printf iostream format print; do
    echo -n "$prg: ";
    (time -p g++-14 --std=c++23 -o build/$prg $prg.cpp) 2>&1 | egrep real | awk '{print $2}' | tr "\n" "s"
    echo -n " => "
    ls -sh build/$prg | awk '{print $1}'
done
