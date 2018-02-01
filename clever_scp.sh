#/bin/bash

BASE_DIR="/Users/dashu/Desktop/leaf_server"
REMOTE_DIR="/root/wuxian/leaf_server"
SSH="root@10.139.39.157"

# check params
if [ $# -ne 1 ] 
then
	echo Usage:./clever_scp.sh file-name
	exit 2
fi

fname=$1
current_dir=`dirname "$0"`
current_dir=`cd "$current_dir"; pwd`

base_dir_len=${#BASE_DIR}
if [ ${#current_dir} -lt $base_dir_len  ]
then
	echo current_dir not cooperate with base_dir,check your dir in $BASE_DIR
	exit 2
fi

if [[ ${current_dir:0:$base_dir_len} != $BASE_DIR ]]
then
	echo current_dir not cooperate with base_dir,check your dir in $BASE_DIR
	exit 3
fi

relative_dir=${current_dir:$base_dir_len}

echo scp $fname $SSH:$REMOTE_DIR$relative_dir/$fname

scp $fname $SSH:$REMOTE_DIR$relative_dir/$fname

