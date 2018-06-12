#!/bin/bash
# Usage: ./service_watcher.sh,it will check service if alive in every 5s,if not restart the service
test=0

if [ $# -ne 1 ]
then
	echo Usage: ./service_watcher.sh proc-id
	exit 2
fi
proc_id=$1

if [ $test -eq 1 ]
then
	while true
	do
		echo service_watcher testing mode !!!!
		sleep 5
	done
	echo good bye,watcher of pid:$proc_id!
	exit 2
fi

. service_util.sh
service_started=`is_service_started`
service_alive=`is_service_alive`
if [[ $service_started == "1" ]] && [[ $service_alive != "1" ]]
then
	echo service started,but service not alive,is there some bug in your code in the first place ?
	echo goodbye...
	exit 2
fi

while true
do
	service_started=`is_service_alive`
	if [[ $service_started == "0" ]]
	then
		echo service not started,restart it now! `date +'%Y-%m-%d %H:%M:%S'`
		/bin/bash restart.sh
		echo goodbye....
		exit 2
	fi
	sleep 5
done
