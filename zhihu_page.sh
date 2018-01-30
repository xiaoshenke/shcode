#!/bin/bash

# test URL:https://zhuanlan.zhihu.com/p/33344222?utm_campaign=rss&utm_medium=rss&utm_source=rss&utm_content=title
# Usage: zhihu_page.sh fromURL 
# for eg. zhihu_page.sh https://zhuanlan.zhihu.com/p/19902052

curl -s -o tmp.html $1 > /dev/null

start=`sed -n '/PostIndex-title/=' tmp.html`
end=`sed -n '/PostIndex-footer/=' tmp.html`
duration=$[end-start+1]

cat tmp.html |tail -n +$start|head -n $duration | gawk 'BEGIN{RS="abcdefgfedcba";FS="<div class=\"PostIndex-footer"} {print $1}' > tmp1.html
cat tmp1.html| gawk 'BEGIN{RS="<p>|<b>|<code class=\"language-text\">"} {print $0}' | sed 's/<[^>]*>//g'

rm -f tmp.html
rm -f tmp1.html

