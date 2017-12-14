#!/bin/bash

PIDS=`ps -ef | grep python | grep manage.py| grep -v grep |awk '{print $2}'`
if [ -z "$PIDS" ]; then
	echo "server does not started!"
	exit 1
fi

for PID in $PIDS ; do
	echo try to kill $PID
	kill $PID > /dev/null 2>&1
done

COUNT=0
while [ $COUNT -lt 1 ]; do
    echo -e ".\c"
    sleep 1
    COUNT=1
    for PID in $PIDS ; do
        PID_EXIST=`ps -f -p $PID `
        if [ -n "$PID_EXIST" ]; then
            COUNT=0
            break
        fi
    done
done

echo "OK!"
echo "PID: $PIDS"
