#!/bin/bash
# Usage: ./service_watcher.sh,it will check service if alive in every 5s,if not restart the service

. service_util.sh

echo service watcher started!

while true
do
	service_started=`is_service_alive`
	echo service_started:$service_started

	if [[ $service_started == "0" ]]
	then
		echo service not started,restart it now!
		sh restart.sh
	fi
	sleep 5
done


