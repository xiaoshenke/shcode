#!/bin/bash

# make sure SERVICE_PORT is always the right one!
SERVICE_PORT=8087

# using pre defined http url to check if service is alive
# 1:alive 0:dead
function is_service_alive {
	i=`curl -s http://127.0.0.1:$SERVICE_PORT/am_i_alive`
	if [[ $i == 1 ]]
	then
		echo 1
	else
		echo 0
	fi
}


# 1:started 0:not started yet!
function is_watcher_started {
        PIDS=`ps aux|grep service_watcher|grep bin|awk '{print $2}'`

	if [[ ${PIDS[*]} != "" ]]
	then
		echo 1
	else
		echo 0
	fi
}





