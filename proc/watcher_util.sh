#!/bin/bash
# some utility of watcher

# 1:started 0:not started yet!
function is_watcher_started {
	if [ $# -ne 1 ]
	then
		echo Usage:is_watcher_started proc-id
		return 0
	fi
	
	proc_id=$1
        PIDS=`ps aux|grep watcher|grep bin|grep $proc_id|awk '{print $2}'`

	if [[ ${PIDS[*]} != "" ]]
	then
		echo 1
	else
		echo 0
	fi
}

function stop_watcher {
	if [ $# -ne 1 ]
	then
		echo Usage:stop_watcher proc-id
		return 0
	fi	
	proc_id=$1
	echo trying to stop watcher of pid:$proc_id...

	watcher_startd=`is_watcher_started $proc_id`
	if [[ $watcher_startd == "1" ]]
	then
		PIDS=`ps aux|grep watcher|grep bin|grep $proc_id|awk '{print $2}'`
		for PID in $PIDS
		do
			kill $PID > /dev/null 2>&1
		done
		echo watcher of pid:$proc_id stoped!
	else
		echo watcher of pid:$proc_id not started!
	fi
}


# check if need to start service watcher of proc-id
function start_watcher {
	if [ $# -ne 1 ]
	then
		echo Usage:start_watcher proc-id
		return 0
	fi
	proc_id=$1

	watcher_started=`is_watcher_started $proc_id`
	if [[ $watcher_started == "0" ]]
	then
		echo watcher of pid:$proc_id not started,start it now..... 
		if [ $test -eq 1 ]
		then
			/bin/bash watcher.sh $proc_id 2>&1 &
		else
			/bin/bash watcher.sh $proc_id >>"watcher.log" 2>&1 &
		fi
	else
		echo watcher already started!
	fi
}
