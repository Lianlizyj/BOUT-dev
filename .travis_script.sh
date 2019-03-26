#!/bin/bash

set -e

#Default flags
COVERAGE=0
UNIT=0
INTEGRATED=0
MMS=0
TESTS=0
MAIN_TARGET=

usage() {
    echo "$0 options are: "
    #Just pull out special comments from this file
    grep "\#\#\#" $0
    exit 1
}

#Handle input flags
while getopts "cuimt:" arg;
do
    case $arg in
	c) ### Run the coverage-post job tasks
	    COVERAGE=1
	    ;;
	u) ### Run the unit tests
	    UNIT=1
	    TESTS=1
	    ;;
	i) ### Run the integrated tests
	    INTEGRATED=1
	    TESTS=1
	    ;;
	m) ### Run the mms tests
	    MMS=1
	    TESTS=1
	    ;;
    t) ### Set target to build
        MAIN_TARGET+=("$OPTARG")
        ;;
	*) ### Show usage message
	    usage
	    ;;
    esac
done

export MAKEFLAGS="-j 2 -k"
echo "****************************************"
echo "Configuring with $CONFIGURE_OPTIONS"
echo "****************************************"
conf=0
time ./configure $CONFIGURE_OPTIONS MAKEFLAGS="$MAKEFLAGS" || conf=$?
if test $conf -gt 0
then
    RED_FG="\033[031m"
    RESET_FG="\033[039m"
    echo -e $RED_FG
    echo "**************************************************"
    echo "Printing config.log:"
    echo "**************************************************"
    echo -e $RESET_FG
    echo
    cat config.log
    echo
    echo -e $RED_FG
    echo "**************************************************"
    echo "Printing config-build.log:"
    echo "**************************************************"
    echo -e $RESET_FG
    echo
    cat config-build.log
    exit $conf
fi
export PYTHONPATH=$(pwd)/tools/pylib/:$PYTHONPATH

for target in ${MAIN_TARGET[@]}
do
    make_exit=0
    time make $target || make_exit=$?
    if [[ $make_exit -gt 0 ]]; then
	make clean > /dev/null
	echo -e $RED_FG
	echo "**************************************************"
	echo "Printing make commands:"
	echo "**************************************************"
	echo -e $RESET_FG
	echo
	make -n $target
	exit $make_exit
    fi
done

if [[ ${UNIT} == 1 ]]
then
    time make check-unit-tests
fi

cd tests/integrated/test-boutcore/collect
valgrind --tool=memcheck --leak-check=full --track-origins=yes --show-leak-kinds=all ./runtest

cd ../legacy-model
valgrind --tool=memcheck --leak-check=full --track-origins=yes --show-leak-kinds=all ./runtest
