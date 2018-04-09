#!/bin/bash
# test URL:https://www.zhihu.com/question/267368623/answer/322792989

# check params
if [ $# -ne 1 ] 
then
	echo Usage:./zhihu_answer.sh http-url
	exit 2
fi

. zhihu_img_util.sh 

is_zhihu_answer_url=`is_zhihu_answer_url $1`
if [[ $is_zhihu_answer_url == "1" ]]
then
	echo not a valid zhihu_answer url,please check your url
	exit 2
fi

curl -s -o tmp.html $1 > /dev/null

# find useful content positions,we will only extract content in [start,end]
start=`sed -n '/AnswerCard/=' tmp.html`
end=`sed -n '/MoreAnswers/=' tmp.html`
duration=$[end-start+1]

# extract text and <image src="http://xxxx"> from origin html file
cat tmp.html |tail -n +$start | gawk 'BEGIN{RS="abcdefgfedcba";FS="<\/main>"} {print $1}' > tmp1.html
cat tmp1.html| gawk 'BEGIN{RS="</div></div></div>|<p>|</p>|</a>|<br>|<figcaption>|</title>|<b>|<code class=\"language-text\">"} {print $0}' | sed '/img data-rawheight/!s/<[^>]*>//g' > tmp2.html

cat tmp2.html

rm -f tmp.html
rm -f tmp1.html
rm -f tmp2.html

