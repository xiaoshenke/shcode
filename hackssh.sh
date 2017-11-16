#!/bin/bash

if [ $# -ne 1 ]
then
	echo Usage:hackssh aaa@bbbb
	exit 2
fi

#eval aaa@bbb to wholehost
wholehost=$1

#host pattern
HOSTPATTERN="@[a-zA-Z0-9_\-\.]+$"

#if pattern not matched,exit
if ! [[ "$wholehost"=~$HOSTPATTERN ]] 
then 
	#echo Pattern matched
	echo Pattern match fail
	exit 2
fi

#eval host from wholehost
host=${wholehost#*@}

#finance machine hosts path
hostfilepath="/etc/hosts_finance"

#read ips from hosts file
ips=`cat $hostfilepath | grep $host`

#Todo: using regex to valid ips

#if no host find in the file,return
if [ ! -n "$ips" ]
then
	echo host not find!
	exit 2
fi

#eval actual ip
ip=${ips%$host*}

#exec ssh command
ssh ${wholehost%@*}@$ip
