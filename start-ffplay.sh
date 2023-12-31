#!/bin/bash

if [[ ! -f ./shared/streamkey ]]; then
	echo "Streamkey not found! Did the stream start?"
	exit -1
fi

STREAMKEY=$(cat ./shared/streamkey)

ffplay rtmp://localhost/app/$STREAMKEY

