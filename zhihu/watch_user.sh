
#!/bin/bash
# Usage: watch_user.sh user:[activity|answer|post|zhuanlan]
# for example ./watch_user.sh chihuowushuang:activity default is activity

# implement: save watched user to file:.watched,every day 9:00 13:20 17:50 20:00 23:00 to check whether anyone of then has new updates,save what's new to file:.news,then once ./what_is_new.sh is called,read and clear .news file

. watched_file_util.sh

watch_file=".watched"

# check params
if [ $# -ne 1 ] 
then
	echo Usage:./watch_user.sh user:activity answer post zhuanlan
	exit 2
fi

param=$1
type=${param##*:}
case "$type" in
activity | answer | post | zhuanlan)
	type=$type ;;
*)
	type="not matched" ;;
esac

if [[ $type == "not matched" ]]
then
	echo only type in activity answer post zhuanlan supported..!
	exit 2
fi

userid=${param%%:*}
echo type:$type
echo userid:$userid

if ! [ -e $watch_file ]
then 
	`init_watched_file $watch_file`
fi

exit 2

running_time=("9:00" "13:20" "17:50" "20:00" "23:00")
running_time=('9 0' '13 20')


function loop_once {
	echo hello
}

function cal_sleep_time {
	# TODO
	echo $[ 100 ]
}


echo ${running_time[@]}

while true
do
	loop_once
	sleep_time=`cal_sleep_time`
	sleep $sleep_time	
done
