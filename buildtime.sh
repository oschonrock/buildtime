#/usr/bin/env bash

CXX=${CXX:-g++-14}
CXXFLAGS=${CXXFLAGS:---std=c++23}

if [[ "$1" == "--pch" ]]
then
    for prg in iostream format print; do
	echo -n "building $prg.h.gch: ";
	(time -p $CXX $CXXFLAGS -x c++-header $prg.h) 2>&1 | egrep real | awk '{print $2}'
    done
else
    rm -f *.gch
fi

mkdir -p build

for prg in puts printf iostream format print; do
    echo -n "$prg: ";
    (time -p $CXX $CXXFLAGS -o build/$prg $prg.cpp) 2>&1 | egrep real | awk '{print $2}' | tr "\n" "s"
    echo -n " => "
    ls -sh build/$prg | awk '{print $1}'
done
