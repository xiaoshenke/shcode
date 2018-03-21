#!/bin/bash

if [ $# -ne 2 ] 
then
	echo Usage:./filebeat_benchmark.sh flush_line_num_per_time sleep_time
	exit 2
fi

flush_num=$1
sleep_time=$2
file="/var/log/wuxian"

echo flush_num:$flush_num,sleep_time:$sleep_time
sleep_num=$[ 0 ]
while true
do
	index=$[ 0 ]
	echo begin to flush $flush_num lines!
	while [ $index -lt $flush_num ]
	do
		echo this is line $[index + 1],after sleep $sleep_num  times >>$file
		index=$[index + 1]
	done
	sleep $sleep_time
	sleep_num=$[sleep_num + 1]
done
