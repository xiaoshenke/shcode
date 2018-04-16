#!/bin/bash
# Used to remove blank lines

# for eg,if a.txt like
# 
#
# this is third line
# then,you can do like this,echo a.txt|./rm_blank_lines.sh,a.txt will be
#
# this is third liine

last=""
while read line;do
	if [ ${#line} -eq 0 ] && [ ${#last} -eq 0 ]
	then
		last=$line
	else
		last=$line
		echo $line
	fi
done


