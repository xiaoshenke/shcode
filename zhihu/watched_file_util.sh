#!/bin/bash

# TODO
function get_activity_users {
	echo "zhangsan"
}

# TODO
function get_answer_users {
	echo "zhangsan" "lisi"
}


function get_post_users {
	echo "zhangsan" "lisi"
}

function get_zhuanlan_users {
	echo "zhangsan" "lisi"
}

# param:username,(id_list)
function update_activity {
	echo 1
}

function update_post {
	echo 1
}

function update_answer {
	echo 1
}

function update_zhuanlan {
	echo 1
}


# 0:fail 1:success
function init_watched_file {
	if [ $# -ne 1 ]
	then 
		echo 0
	else
		watch_file=$1
		if ! [ -e $watch_file ]
		then
			echo file:$watch_file not exist,create it
			touch $watch_file
		fi
		echo "activity:
activity_begin
activity_end

answer:
answer_begin
answer_end

post:
post_begin
post_end

zhuanlan:
zhuanlan_begin
zhuanlan_end" > $watch_file
		echo 1
	fi
}


