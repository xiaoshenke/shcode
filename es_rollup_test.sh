#!/bin/bash
# Usage: test elasticsearch rollup behavior
# here,HOST1,HOST2,HOST3 form elastic cluster,this shell will try to call es's _cat/node api to check if es service is alive.

HOST1="10.1.3.117"
HOST2="10.1.3.118"
HOST3="10.1.2.213"
hosts=($HOST1 $HOST2 $HOST3)

while true
do 
	success=0
	for host in ${hosts[@]}
	do
		now=`date +'%Y-%m-%d %H:%M:%S'`
		echo trying host:$host $now
		ret=`curl -s --max-time 5 $host:9200/_cat/nodes?pretty`
		if [[ $ret =~ "esnode" ]]
		then
			success=1
			break
		fi
	done
	if [ $success -eq 1 ]
	then
		echo "success"
	else
		echo "fail"
	fi
	sleep 2

done
