#!/bin/bash
# test URL:https://mp.weixin.qq.com/s?__biz=MzI4NTM5MTU2NQ==&mid=2247485080&idx=1&sn=960fe89dfb78bfbe6b9d30a02095f7e3&chksm=ebeda93adc9a202ca40d612028b2d343971caba9f9b61e93882a50c92dbc6ee4587d025153c1&scene=0&key=b738a60688b96386ef9e07b1648564a078420abb78fd1ecf7fc4e5001a29b68d8fc7bd8f4043d4c776c3abf3d49cb2e17691b0c64f60f20fa1a3012eeb3c8f290d143d5f92e10486f1f5ed6660984f7d&ascene=0&uin=MjM0MzEwMzE1&devicetype=iMac+MacBookPro12%2C1+OSX+OSX+10.11.2+build(15C50)&version=12020610&nettype=WIFI&lang=en&fontScale=100&pass_ticket=tlN3cjomhjp4cQltFKasxK8V6zq1YgVeHYMN5Zm%2FntQ%3D

# check params
if [ $# -ne 1 ] 
then
	echo Usage:./wechat_page.sh http-url
	exit 2
fi

curl -s -o tmp.html $1 > /dev/null

# find useful content positions,we will only extract content in [start,end]
start=`sed -n '/js_article/=' tmp.html`
end=`sed -n '/js_preview_reward_wording/=' tmp.html`
duration=$[end-start+1]

# extract text and <image src="http://xxxx"> from origin html file
cat tmp.html |tail -n +$start|head -n $duration | gawk 'BEGIN{RS="abcdefgfedcba";FS="<div class=\"PostIndex-footer"} {print $1}' > tmp1.html
cat tmp1.html| gawk 'BEGIN{RS="<figure>|</figure>|<p>|</p>|</title>|<b>|<code class=\"language-text\">"} {print $0}' | sed '/img src/!s/<[^>]*>//g' > tmp2.html

# fix not able to delete meaningless down messages
start=1
end=`sed -n '/first_sceen__time/=' tmp2.html`
duration=$[end-start]
cat tmp2.html | tail -n +$start|head -n $duration > tmp1.html
cat tmp1.html > tmp2.html

# FIXME: ./rm_blank_lines.sh not always works fine...still has some bug
cat tmp2.html | ./rm_blank_lines.sh 
