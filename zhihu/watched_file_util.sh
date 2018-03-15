#!/bin/bash

# FIXME:has some bug working with brackets
function get_activity_users {
	watch_file=$1
	cat $watch_file  | gawk 'BEGIN{FS=":"} /activity:/{print $2}' > tmp
	#cat tmp | gawk 'BEGIN{RS=","} {print $0}' > tmp2
	a=`cat tmp`
	rm -f tmp

	OLD_IFS="$IFS"
	IFS=","
	users=($a)
	IFS="$OLD_IFS"
	echo ${users[@]}
}

# 0:false 1:true
function contains_user_in_activity {
	user=$1
	watch_file=$2
	users=`get_activity_users $watch_file`
	success=0
	for u in $users
	do
		if [[ $user == $u ]]
		then
			success=1
			echo 1
		fi
	done
	if [ $success -eq 0 ]
	then
		echo 0
	fi
}

# TODO
function update_news_list_in_activity {
	echo 0
}

# param 1:username 2:watchfile
function get_news_list_in_activity {
	username=$1
	watch_file=$2

	start=`cat $watch_file | sed -n '/activity_begin/=' `
	end=`cat $watch_file | sed -n '/activity_end/=' `
	duration=$[end-start+1]

	cat $watch_file |tail -n +$start|head -n $duration > tmp
	cat tmp |grep "^$username:"  | gawk 'BEGIN{FS=":"} {print $2}' > list.html

	a=`cat list.html`
	rm -f tmp
	rm -f list.html

	OLD_IFS="$IFS"
	IFS=","
	users=($a)
	IFS="$OLD_IFS"
	echo ${users[@]}
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


