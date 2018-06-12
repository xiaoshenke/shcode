#!/bin/bash
test=1

. service_util.sh
pid=`get_service_pid`

. watcher_util.sh
stop_watcher $pid

