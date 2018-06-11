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
while true
do
	service_started=`is_service_alive`
	if [[ $service_started == "0" ]]
	then
		echo service not started,restart it now! `date +'%Y-%m-%d %H:%M:%S'`
		/bin/bash restart.sh
	fi
	sleep 5
done


