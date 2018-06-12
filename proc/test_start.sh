#!/bin/bash
test=1

# make sure replace this with your-real-function

. service_util.sh
pid=`get_service_pid_till_success`

. watcher_util.sh
start_watcher $pid

