#!/bin/bash
# Used to copy multi file to destinetion
# for eg, find *|grep xyz|./multi_copy.sh to-path

# check params

if [ $# -ne 1 ]
then
        echo Usage: find *|grep xyz|./multi_copy.sh to-path
        exit 2
fi

while read line;do
	if [ ! -f $line ]
	then
		echo ignore directory $line .
	else
		echo exeute cp $line $1
		cp $line $1
	fi
done

