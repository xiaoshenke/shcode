#!/bin/bash
#Usage: zhihu_img.sh fromURL for eg. zhihu_img.sh https://zhuanlan.zhihu.com/p/19902052

if [ $# -ne 1 ] 
then
	echo Usage:./zhihu_img.sh fromURL
	exit 2
fi

curl -s -o tmp.html $1 > /dev/null

urls=`gawk 'BEGIN{RS=";"} /http:[0-9picFu\\\]*.zhimg.com/{print $0}' tmp.html`

for url in $urls:
do
#	new_url=${url[@]//u002F//} `echo $url | sed 's!u002F!/!g'` --> Fixme: slash and backslash replacement....

	new_url=$url
	new_url=${new_url%\\\&quot*}
	new_url=${new_url##*com\\u002F}	
	new_url="http://pic4.zhimg.com/"$new_url

	echo begin to download: $new_url

	savefile=${new_url:0-15:15}
	curl -s -o $savefile $new_url > /dev/null 2>&1 
	open -a Preview $savefile
done

rm -f tmp.html



