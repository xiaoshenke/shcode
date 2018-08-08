#!/bin/bash
# Used to count lines,
# for eg,if you want to count all your py file line count,
# use find *|grep -v other|grep [.]py|grep -v [.]pyc|./count_lines.sh

num=0
while read line;do
	if [ -f $line ]
	then
		echo count file:$line
		tmp=`cat $line | wc -l`
		num=$[num+tmp]
	fi
done

echo $num
