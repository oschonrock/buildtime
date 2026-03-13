#/usr/bin/env bash

CXX=${CXX:-g++-14}
CXXFLAGS=${CXXFLAGS:---std=c++23}

if [[ "$1" == "--pch" ]]
then
    for prg in iostream format print fmtformat fmtformat; do
	echo -n "building $prg.h.gch: ";
	if [[ "$prg" == "fmt"* ]]
	then
	    CXXF="$CXXFLAGS -Ifmt/include -Lfmt/build";
	else
	    CXXF="$CXXFLAGS"
	fi
	(time -p $CXX $CXXF -x c++-header $prg.h) 2>&1 | egrep real | awk '{print $2}'
    done
else
    rm -f *.gch
fi

mkdir -p build

# for prg in puts printf iostream format print; do
for prg in puts printf iostream format print fmtformat fmtprint; do
    echo -n "$prg: ";
    if [[ "$prg" == "fmt"* ]]
    then
	CXXF="$CXXFLAGS -Ifmt/include -Lfmt/build";
	LDFLAGS="-lfmt" # needs to go after the source
    else
	CXXF="$CXXFLAGS"
	LDFLAGS="-lstdc++exp"
    fi
    
    (time -p $CXX $CXXF -o build/$prg $prg.cpp $LDFLAGS) 2>&1 | egrep real | awk '{print $2}' | tr "\n" "s"
    echo -n " => "
    strip build/$prg
    ls -sh build/$prg | awk '{print $1}'
done
