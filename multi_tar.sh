#!/bin/bash
# Used to tar xvzf multi file to destination
# for eg, find *|grep xyz|./multi_tar.sh to-file

if [ $# -ne 1 ]
then
        echo Usage: find *|grep xyz|./multi_tar.sh to-file
        exit 2
fi

# step1: check whether .tmp dir exist
TMP_DIR="m_tar"
if [ -e $TMP_DIR ] && [ -d $TMP_DIR ]
then
	echo $TMP_DIR exist!!! you should clear the dir first to call this sh!
	exit 1
fi

# step2: copy files to dir
mkdir $TMP_DIR
while read line;do
	if [ ! -f $line ]
	then
		echo ignore directory $line .
	else
		echo exeute cp $line $TMP_DIR
		cp $line $TMP_DIR
	fi
done

# step3: execute tar
tar -cvzf $1 $TMP_DIR

# step4: remove dir
rm -r $TMP_DIR

