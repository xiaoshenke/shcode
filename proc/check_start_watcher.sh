#!/bin/bash
# Usage: ./check_start_watcher.sh or call it in another shell script(your service start.sh) /bin/bash check_start_watcher.sh
. service_util.sh

watcher_started=`is_watcher_started`
if [[ $watcher_started == "0" ]]
then
	echo watcher not start,start now! 
	/bin/bash service_watcher.sh >"watcher.log" 2>&1 &
else
	echo watcher already started!
fi

