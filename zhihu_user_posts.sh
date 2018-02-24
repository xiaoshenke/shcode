#!/bin/bash
# test URL:https://www.zhihu.com/people/baskice/posts?page=2

# check params
if [ $# -ne 1 ] 
then
	echo Usage:./zhihu_user_posts.sh http-url
	exit 2
fi

. zhihu_img_util.sh 

is_zhihu_user_posts_url=`is_zhihu_user_posts_url $1`
if [[ $is_zhihu_user_posts_url == "1" ]]
then
	echo not a valid zhihu_user_posts url,please check your url
	exit 2
fi

curl -s -o tmp.html $1 > /dev/null

# find useful content positions,we will only extract content in [start,end]
start=`sed -n '/List-header/=' tmp.html`
end=`sed -n '/Pagination/=' tmp.html`
duration=$[end-start+1]

# FIXME: not working these way

# extract text and <image src="http://xxxx"> from origin html file
cat tmp.html |tail -n +$start | head -n $duration > tmp1.html
cat tmp1.html| gawk 'BEGIN{RS="<p>|</p>|<figcaption>|</title>|<b>|<code class=\"language-text\">"} {print $0}' | sed '/img data-rawheight/!s/<[^>]*>//g' > tmp2.html

cat tmp2.html

#rm -f tmp.html
#rm -f tmp1.html
#rm -f tmp2.html

