#!/bin/bash

# a mv command which cat be used in shell pipeline, 
# Usage example:echo a.txt| ./mv.sh toPath 

if [ $# -ne 1 ] 
then
	echo Usage:./mv.sh toPath
	exit 2
fi

DIR=$1
echo $DIR

while read line
do
	echo $line; 
	mv $line $DIR;
done


