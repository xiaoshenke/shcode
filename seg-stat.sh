
#!/bin/bash

##Usage: sh seg.sh fromFile [toFile] 

if [ $# -eq 0 ] || [ $# -gt 2 ]
then
	echo Usage:seg-stat fromFile [toFile]
	exit 2
fi

java -jar Playgroud/Segmentation-1.0-jar-with-dependencies.jar $1 .seg.tmp

if [ $# -eq 2 ]
then
	java -jar Playgroud/NER-Experiment-1.0-jar-with-dependencies.jar .seg.tmp $2
else
	java -jar Playgroud/NER-Experiment-1.0-jar-with-dependencies.jar .seg.tmp
fi

rm -f .seg.tmp

