#!/bin/bash

function find_uwsgi_master_pos {
	times=(`echo "$@"`)
	len=${#times[*]}

	i=0
	find=0
	cur=0
	while [ $i -lt $len ]
	do
		t=${times[i]}
		t=${t//:/}
		t=${t//./}

		# string to int
		t=`expr $t`

		if [ $cur -eq 0 ]
		then
			cur=$t
			find=$i
		else

			if [ $t -gt $cur  ]
			then
				cur=$t
				find=$i
			fi
		fi
		i=$[i+1]
	done
	echo $find
}


TIMES=`ps -ef | grep uwsgi| grep -v grep |awk '{print $7}'`
if [ -z "$TIMES" ]; then
        echo "server does not started!"
        exit 1
fi

pos=`find_uwsgi_master_pos ${TIMES[@]}`
pos=`expr $pos`

PIDS=`ps -ef | grep uwsgi| grep -v grep |awk '{print $2}'`
echo we got all uwsgi instances:${PIDS[@]}

# string to array
PIDS=($PIDS)

echo we will kill master pid:${PIDS[pos]}...

kill -9 ${PIDS[pos]}

