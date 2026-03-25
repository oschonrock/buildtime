#/usr/bin/env bash

function run() {
    $CXX --version | grep -E "GCC|clang" | tr "\n" "s"
    echo -n " with $STDLIB"
    if [[ "$1" == "--pch" ]]
    then
	echo " with pre compiled headers"
    else
	echo
    fi
    
    CXXFLAGS="-std=c++23"
    if [[ "$CXX" == "clang++" ]]
    then
	# only for clang, gcc usually doesn't support this switch
	CXXFLAGS="$CXXFLAGS -stdlib=$STDLIB"
	EXT="pch"
    else
	EXT="gch"
    fi
    cd fmt
    echo -n "compiling {fmt} with the above..."
    cmake -GNinja -B build/$CXX -DCMAKE_CXX_FLAGS="'$CXXFLAGS'" -DCMAKE_CXX_COMPILER="$CXX" -DCMAKE_BUILD_TYPE=Release >&-
    cmake --build build/$CXX >&-
    echo done
    cd ..
    
    rm -f build/*
    prgs="puts puts_string iostream format print fmtformat fmtprint"
    
    if [[ "$1" == "--pch" ]]
    then
	for prg in $prgs
	do
	    echo -n "building $prg.h.$EXT: ";
	    if [[ "$prg" == "fmt"* ]]
	    then
		CXXF="$CXXFLAGS -Ifmt/include -Lfmt/build/$CXX";
	    else
		CXXF="$CXXFLAGS"
	    fi
	    (time -p $CXX $CXXF -x c++-header $prg.h) 2>&1 | grep -E real | awk '{print $2}'
	    # echo $CXX $CXXF -x c++-header $prg.h
	    # $CXX $CXXF -x c++-header $prg.h
	done
    else
	rm -f *.$EXT
    fi

    for prg in $prgs
    do
	echo -n "$prg: ";
	if [[ "$prg" == "fmt"* ]]
	then
	    CXXF="$CXXFLAGS -Ifmt/include -Lfmt/build/$CXX";
	    LDFLAGS="-lfmt" # needs to go after the source
	else
	    CXXF="$CXXFLAGS"
	    LDFLAGS=""
	fi
	if [[ "$1" == "--pch" && "$CXX" == "clang++" ]]
	then
	    # clang needs to be told to use the pch explicitly
	    CXXF="$CXXF -include-pch $prg.h.pch"
	fi
	
	(time -p $CXX $CXXF -o build/$prg $prg.cpp $LDFLAGS) 2>&1 | grep -E real | awk '{print $2}' | tr "\n" "s"
	# echo $CXX $CXXF -o build/$prg $prg.cpp $LDFLAGS
	# $CXX $CXXF -o build/$prg $prg.cpp $LDFLAGS
	echo -n " => "
	strip build/$prg
	ls -sh build/$prg | awk '{print $1}'
    done
}

CXX=g++
STDLIB=libstdc++
run 

echo

CXX=clang++
STDLIB=libc++
run

echo

CXX=g++
STDLIB=libstdc++
run --pch

echo

CXX=clang++
STDLIB=libc++
run --pch
