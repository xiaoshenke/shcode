#!/bin/bash
# test URL:https://zhuanlan.zhihu.com/p/33344222?utm_campaign=rss&utm_medium=rss&utm_source=rss&utm_content=title

# init save_image flag 0:not save 1:save
save_image=0
while [ -n "$1" ]
do
	case "$1" in
	-s | -save_image) 
		save_image=1 ;;
	*) 
		break;;
	esac
	shift
done 


# check params
if [ $# -ne 1 ] 
then
	echo Usage:./zhihu_pape_img.sh http-url
	exit 2
fi

. zhihu_img_util.sh 

is_zhihu_page_url=`is_zhihu_page_url $1`
if [[ $is_zhihu_page_url == "1" ]]
then
	echo not a valid zhihu_page url,please check your url
	exit 2
fi

curl -s -o tmp.html $1 > /dev/null

# find useful content positions,we will only extract content in [start,end]
start=`sed -n '/Post-NormalMain/=' tmp.html`
end=`sed -n '/Zi--Comment/=' tmp.html`
duration=$[end-start+1]

# extract text and <image src="http://xxxx"> from origin html file
cat tmp.html |tail -n +$start|head -n $duration | gawk 'BEGIN{RS="abcdefgfedcba";FS="<div class=\"PostIndex-footer"} {print $1}' > tmp1.html
cat tmp1.html| gawk 'BEGIN{RS="<figure>|</figure>|<p>|</p>|</title>|<b>|<code class=\"language-text\">"} {print $0}' | sed '/img src/!s/<[^>]*>//g' > tmp2.html

# fix not able to delete meaningless down messages
start=[ 1 ]
end=`sed -n '/Zi--Comment/=' tmp2.html`
duration=$[end-start]
cat tmp2.html | tail -n +$start|head -n $duration > tmp1.html
cat tmp1.html > tmp2.html

# find line numbers of all image positions,we will replace urls using these line numbers
ori_lines=`cat tmp2.html |sed -n '/img src/='`
lines=( )
for line in $ori_lines
do
	index=${#lines[@]}
	lines[ $index ]=$line
done

# find all image http-urls from html
urls=( )
for line in $ori_lines
do
	#cat tmp2.html | tail -n +$line | head -n 1 | gawk 'BEGIN{RS="\""} /https?:[0-9picFu\/\\]*.zhimg.com/{print $0}' | head -n 1 > tmp_line
	cat tmp2.html | tail -n +$line | head -n 1 | gawk 'BEGIN{RS="\""} /https?:[0-9picFu\/\\]*.zhimg.com/{print $0}' > tmp_lines
	images=`cat tmp_lines`
	image=`find_big_image ${images[*]}`
	find_big_image ${images[*]} > tmp_line
	index=${#urls[@]}
	url=`cat tmp_line`
	urls[ $index ]=$url
done

rm -f tmp_line
rm -f tmp_lines

# replace http-urls using line numbers
index=$[ 0 ]
lenth=${#urls[@]}
while [ $index -lt $lenth ]
do
	line=${lines[ $index ]}
	url=${urls[ $index ]}
	# sed 'c\' -> replace command
	sed "$line c\\
$url
" tmp2.html > tmp3.html
	cat tmp3.html > tmp2.html
	index=$[index + 1]
done

if [ $save_image -ne 1 ]
then
	cat tmp2.html
#|sed '='
	rm -f tmp.html
	rm -f tmp1.html
	rm -f tmp2.html
	rm -f tmp3.html
	exit 2
fi

jpg_list=`list_images`
jpg_size=${#jpg_list[@]}
jpg_index=$[ jpg_size ]

index=$[ 0 ]
lenth=${#urls[@]}
while [ $index -lt $lenth ]
do
	line=${lines[ $index ]}
	url=${urls[ $index ]}
	save_name=$[ jpg_index + $index ].jpg
	curl -s -o $save_name  $url > /dev/null 2>&1
	sed "$line c\\
$save_name
" tmp2.html > tmp3.html
	cat tmp3.html > tmp2.html
	index=$[index + 1]
done

cat tmp2.html 
#| sed '='

rm -f tmp3.html
rm -f tmp.html
rm -f tmp1.html
rm -f tmp2.html

