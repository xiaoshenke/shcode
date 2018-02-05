#!/bin/bash

# a ulity which auto compress jpgs under $BASE_DIR in every 5 seconds..
# Usage: ./auto_compress_jpg.sh &

BASE_DIR="/Users/wuxian/Desktop"

BASE_DIR_LEN=${#BASE_DIR}
echo BASE_DIR_LEN:$BASE_DIR_LEN

cvt=`type convert`
not_found="not found"

if [[ $cvt =~ $not_found ]]
then 
	echo imagemagick not installed,you should install imagemagick first,linux:apt-get install imagemagick,mac:brew install imagemagick
	exit 2
fi

function convert_image {
	files=`find $BASE_DIR -maxdepth 1 -size +200k`
	for f in $files:
	do
		fname=${f:$[ BASE_DIR_LEN + 1 ]}
		if [[ $fname =~ ".jpg" ]]
		then
			# if end with _c.jpg,means we have already compressed it 
			if [[ $fname =~ "_c.jpg" ]]
			then 
				continue
			fi
			fnew_name=${f/%.jpg/_c.jpg}
			echo convert -resize 80%x80% $f $fnew_name

			# TODO: quality not good enough..
			convert -resize 80%x80% $f $fnew_name
			rf -f $f
		fi
	done
}

while true
do
	convert_image
	sleep 5
done

