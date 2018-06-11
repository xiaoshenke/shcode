#!/bin/bash
test=1

# make sure replace this with your-real-function
function get_service_pid {
	PIDS=`ps -ef | grep python | grep manage.py| grep -v grep |awk '{print $2}'`
	for pid in $PIDS
	do
		echo $pid
		break
	done

	if [ $test -eq 1 ]
	then
		echo 123
	fi
}

. service_util.sh
pid=`get_service_pid`
stop_watcher $pid

