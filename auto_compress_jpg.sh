#!/bin/bash

# a ulity which auto compress jpgs under $BASE_DIR in every 5 seconds..
# Usage: ./auto_compress_jpg.sh &

BASE_DIR="/Users/dashu/Desktop"
BASE_DIR_LEN=${#BASE_DIR}

cvt=`type convert`
not_found="not found"

if [[ $cvt =~ $not_found ]]
then 
	echo imagemagick not installed,you should install imagemagick first,linux:apt-get install imagemagick,mac:brew install imagemagick
	exit 2
fi

function do_if_convert {
	f=(`echo "$@"`)
	if [[ ${f[*]} =~ ".png" ]]
	then
		if [[ ${f[*]} =~ "_c.png" ]]
		then
			# already exists,just confinue
			continue
		fi
		size="$(wc -c < "${f[*]}")"
		# only those bigger than 200k pngs will be compressed
		if [ $size -gt 204800 ]
		then 
			fnew_name=${f[*]/%.png/_c.png}
			echo convert -resize 80%x80% ${f[*]} ${fnew_name[*]}
			convert -resize 80%x80% "${f[*]}" "${fnew_name[*]}"
			#rm -f $f
		fi
	fi
}

function convert_image {
	# actually,using find is ok also
	#files=`find $BASE_DIR -maxdepth 1 -size +200k`
	ls -1 $BASE_DIR | while read word;do
do_if_convert ${word[*]}
done
}

while true
do
	convert_image
	sleep 5
done

