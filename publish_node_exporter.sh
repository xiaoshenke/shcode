#!/bin/bash
# Usage: ./pusblish_node_exporter host_list [to_path]
# for eg. ./pusblish_node_exporter.sh 10.0.0.10;10.0.0.11 /home/

NODE_FILE="node_exporter-0.15.2"
NODE="node_exporter"
BEGIN_PORT=9100

if [ $# -lt 1 ]
then
	echo Usage: ./pusblish_node_exporter host_list [to_path]
	exit 2
fi

to_path="/root/"
if [ $# -ge 2 ]
then
	to_path=$2
fi

host_list=$1
saveIFS=$IFS
IFS=";"
host_list=($host_list)
IFS=$saveIFS

for host in ${host_list[*]}
do
	echo scp $NODE_FILE.tar.gz root@$host:$to_path$NODE_FILE.tar.gz
	scp $NODE_FILE.tar.gz root@$host:$to_path$NODE_FILE.tar.gz	
	ssh root@$host bash -c "'
echo cd $to_path
cd $to_path
echo tar -xvzf $NODE_FILE.tar.gz $NODE_FILE
tar -xvzf $NODE_FILE.tar.gz $NODE_FILE
echo cd $NODE_FILE
cd $NODE_FILE
echo ./$NODE 
./$NODE >node.log 2>&1 &
sleep 1
tail -n 100 node.log|grep Listening
tail -n 100 node.log|grep fatal
'"
done

