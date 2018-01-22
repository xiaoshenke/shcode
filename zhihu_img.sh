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


images=( )
# use Array:images to filter duplicate urls 0:success 1:false
function should_download {
	if [ $# -ne 1 ]
	then
		echo $[ 1 ]
	fi
	local find=0
	input_image=$1
	for value in ${images[*]}
	do
		if [[ ${value:0:10} == ${input_image:0:10} ]]
		then
			find=1
			break
		fi
	done
	if [ $find -eq 1 ]
	then
		echo $[ 1 ]
	else
		echo $[ 0 ]
	fi
}

# init open_image flag which dertimines whether open image after success download it ->  0:not open 1:open
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

# check params
if [ $# -ne 1 ] 
then
	echo Usage:./zhihu_img.sh [-o -open] fromURL
	exit 2
fi

# extract all urls
curl -s -o tmp.html $1 > /dev/null
gawk 'BEGIN{RS=";"} {print $0}' tmp.html > tmp1.html
start=`sed -n '/uthorName&/=' tmp1.html`
end=`sed -n '/new Date/=' tmp1.html`
duration=$[end-start]
cat tmp1.html |tail -n +$start|head -n $duration > tmp2.html
urls=`gawk '/https?:[0-9picFu\\\]*.zhimg.com/{print $0}' tmp2.html`

for url in $urls:
do
# dealing with each url
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
	
	should_d=`should_download $new_url`
	if [ $should_d -eq 1 ]
	then
		#we have alread download it 
		continue
	fi
	index=${#images[@]}
	images[ $index ]=$new_url

	new_url="http://pic4.zhimg.com/"$new_url
	echo begin to download: $new_url

	savefile=${new_url:0-15:15}
	curl -s -o $savefile $new_url > /dev/null 2>&1
	if [ $open_image -eq 1  ]
	then
		open -a Preview $savefile
	fi
done

rm -f tmp.html
rm -f tmp1.html
rm -f tmp2.html
