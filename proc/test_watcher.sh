#!/bin/bash

. service_util.sh

watcher_started=`is_watcher_started`
if [[ $watcher_started == "0" ]]
then
	echo watcher not start,start now! 
	sh service_watcher.sh >"watcher.log" 2>&1 &
else
	echo watcher already started!
fi

