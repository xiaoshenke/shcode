#!/bin/bash

# function: list all all .jpg images under dir
function list_images {
	local dir=""
	if [ -n "$1" ]
	then
		dir=$1
	else
		dir=`dirname "$0"`
		dir=`cd "$dir";pwd`
	fi
	list=`find $dir -name *[.]jpg`
	echo ${list[@]}
}

function find_big_image {
	images=(`echo "$@"`)
	for image in ${images[*]}
	do
		valid=`is_valid_url $image`
		if [[ $valid == "0" ]]
		then
			echo $image
			break
		fi
	done
}

function extract_url_id {
	url=$1
	url=${url##*com/}
	url=${url%%.jpg}
	echo $url
}


# 0:success 1:false compare name
function should_download {
	local find=0
	input_image=$1
	shift
	images=(`echo "$@"`)
		
	index=${#images[@]}
	for value in ${images[*]}
	do
		value=`extract_url_id $value`
		if [[ ${value:0:10} == ${input_image:0:10} ]]
		then
			find=1
			break
		fi
	done
	if [ $find -eq 1 ]
	then
		return 1
	else
		return 0
	fi
}

function is_zhihu_page_url {
	if [ $# -ne 1 ]
	then
		echo 1
	fi
	ZHIHU_PAGE_URL_PATTERN="^https:[/][/]zhuanlan[.]zhihu[.]com[/]p[/][0-9]+[?]?"
	url=$1
	if [[ $1 =~ $ZHIHU_PAGE_URL_PATTERN  ]]
	then 
		echo 0
	else
		echo 1
	fi
}

function is_zhihu_answer_url {
	if [ $# -ne 1 ]
	then
		echo 1
	fi
	ZHIHU_ANSWER_URL_PATTERN="^https:[/][/]www[.]zhihu[.]com[/]question[/][0-9]+[/]answer[/][0-9]+"
	url=$1
	if [[ $1 =~ $ZHIHU_ANSWER_URL_PATTERN  ]]
	then 
		echo 0
	else
		echo 1
	fi
}



# 0:success 1:false those url which ends with "_r.jpg" is valid
function is_valid_url {
	if [ $# -ne 1 ]
	then 
		echo 1
	fi
	name=$1
	#get rid of .jpg
	name=${name%%.jpg*}
	
	if [[ ${name:0-2:2} == "_r" ]]
	then 
		echo 0
	else
		echo 1
	fi
}

# input urls:[] return urls:[]
function return_valid_urls {
	# attention...array should be passed like this
	input_urls=(`echo "$@"`)
	images=( )
	for url in ${input_urls[*]}
	do
		
		valid=`is_valid_url $url`
		if [[ $valid == "1" ]]
		then 
			continue
		fi
		new_url=`function extract_url_id $new_url`
		
		should_download $new_url ${images[*]}
		ret=$?
		if [ $ret -eq 1 ]
		then 
			continue
		fi
		index=${#images[@]}
		images[ $index ]=$url
		#break
	done
	echo ${images[@]}
}

