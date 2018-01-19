#!/bin/bash
#Usage: zhihu_img.sh [-o -open] fromURL for eg. zhihu_img.sh https://zhuanlan.zhihu.com/p/19902052

# 0:success 1:false those url which ends with "_r.jpg" is valid
function is_valid_url {
	if [ $# -ne 1 ]
	then 
		return 1
	fi
	name=$1
	#get rid of .jpg
	name=${name%%.jpg*}
	#get last 2 chars	
	if [[ ${name:0-2:2} == "_r" ]]
	then 
		return 0
	else
		return 1
	fi
}

# init open_image flag ->  0:not open 1:open
open_image=0
while [ -n "$1" ]
do
	case "$1" in
	-o | -O | -open | -Open) 
		open_image=1 ;;
	*) 
		break;;
	esac
	shift
done 

if [ $# -ne 1 ] 
then
	echo Usage:./zhihu_img.sh [-o -open] fromURL
	exit 2
fi

curl -s -o tmp.html $1 > /dev/null

urls=`gawk 'BEGIN{RS=";"} /https?:[0-9picFu\\\]*.zhimg.com/{print $0}' tmp.html`

for url in $urls:
do
#	new_url=${url[@]//u002F//} `echo $url | sed 's!u002F!/!g'` --> Fixme: slash and backslash replacement....
	new_url=$url
	new_url=${new_url%\\\&quot*}
	new_url=${new_url##*com\\u002F}	

	is_valid_url $new_url
	if [ $? -ne 0 ]
	then
		#echo $new_url not valid,continue
		continue
	fi

	new_url="http://pic4.zhimg.com/"$new_url
	echo begin to download: $new_url

	savefile=${new_url:0-15:15}
	curl -s -o $savefile $new_url > /dev/null 2>&1
	if [ $open_image -eq 1  ]
	then
		#echo open -a Preview $savefile
		open -a Preview $savefile
	fi
done

rm -f tmp.html
