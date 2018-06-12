#!/bin/bash
# service utilitys,when you use it in PRODUCTION,you must custom @is_service_alive,@is_service_started,@get_service_pid

test=0
function is_service_alive {
	SERVICE_PORT=8086
	i=`curl -s http://127.0.0.1:$SERVICE_PORT/am_i_alive`
	if [[ $i == "1" ]]
	then
		echo 1
	else
		echo 0
	fi
}

function is_service_started {
	PIDS=`netstat -apn | grep ':8086' | awk '/tcp/{print $NF}'`
	PIDS=${PIDS[*]%%/*}
	if [[ ${PIDS[*]} != "" ]]
	then
		echo 1
	else
		echo 0
	fi	
}

function get_service_pid {
	PIDS=`netstat -apn | grep ':8086' | awk '/tcp/{print $NF}'`
	PIDS=${PIDS[*]%%/*}
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

function get_service_pid_till_success {
	pid=`get_service_pid`
	while true
	do
		if [ "$pid" -gt 0  ] 2>/dev/null;
		then
			break
		else
			sleep 1
			pid=`get_service_pid`
			#echo service pid:$pid
		fi
	done
	echo $pid
}
