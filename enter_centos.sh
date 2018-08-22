#!/bin/bash

if [ $# -ge 1 ]
then
	sudo docker run -p 1234:1234 -v /Users/dashu/Desktop/docker-share/:/home -i -t e934aafc2206 /bin/bash
else
	sudo docker run -v /Users/dashu/Desktop/docker-share/:/home -i -t e934aafc2206 /bin/bash
fi

