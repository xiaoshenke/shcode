#!/bin/bash

# test URL:https://zhuanlan.zhihu.com/p/33344222?utm_campaign=rss&utm_medium=rss&utm_source=rss&utm_content=title

. zhihu_img_util.sh 

curl -s -o tmp.html $1 > /dev/null

start=`sed -n '/PostIndex-title/=' tmp.html`
end=`sed -n '/PostIndex-footer/=' tmp.html`
duration=$[end-start+1]

# get text and img html
cat tmp.html |tail -n +$start|head -n $duration | gawk 'BEGIN{RS="abcdefgfedcba";FS="<div class=\"PostIndex-footer"} {print $1}' > tmp1.html
cat tmp1.html| gawk 'BEGIN{RS="<p>|</p>|</title>|<b>|<code class=\"language-text\">"} {print $0}' | sed '/img src/!s/<[^>]*>//g' > tmp2.html


# get html line numbers
ori_lines=`cat tmp2.html |sed -n '/img src/='`
lines=( )
for line in $ori_lines
do
	index=${#lines[@]}
	lines[ $index ]=$line
done

# get urls from html
urls=( )
for line in $ori_lines
do
	cat tmp2.html | tail -n +$line | head -n 1 | gawk 'BEGIN{RS="\""} /https?:[0-9picFu\/\\]*.zhimg.com/{print $0}' | head -n 1 > tmp_line
	index=${#urls[@]}
	url=`cat tmp_line`
	urls[ $index ]=$url
	rm -f tmp_line
done
echo ${urls[*]}

index=$[ 0 ]
lenth=${#urls[@]}

while [ $index -lt $lenth ]
do
	line=${lines[ $index ]}
	url=${urls[ $index ]}
	# replace origin <img src=xxx> with http:// of every position of <img>s
	# but because http:// has many special charactors,we cannot simply use sed 'c'  we have do some ugly things... p304
	# TODO: sed 'r' p304
	
	index=$[index + 1]
	break
done

#rm -f tmp.html
#rm -f tmp1.html
#rm -f tmp2.html


# extract html urls
#cat tmp2.html | gawk '/img src/{print $0}'| gawk 'BEGIN{RS="\""} /https?:[0-9picFu\/\\]*.zhimg.com/{print $0}' > tmp_urls
#urls=`cat tmp_urls`
#clean_urls=`return_valid_urls ${urls[*]}`
#echo ${clean_urls[*]}


