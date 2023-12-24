#!/bin/bash

STREAMKEY_LOCATION="/tmp/streamkey"

# remove stale keys
rm "$STREAMKEY_LOCATION"

if [[ "$RTMP_HOST" == "" ]]; then
  echo "RTMP_HOST not set; exitting"
  exit -1
fi

# create hls directory if it doesn't exist
if [ ! -d "/shared/hls" ]; then
  mkdir -p /shared/hls
  chmod 777 /shared/hls
fi

# Infinite loop
while true; do
  rm -r /shared/hls/*
  echo "Waiting for streamkey to be published"
  # Loop until streamkey file exists
  while [ ! -f "$STREAMKEY_LOCATION" ]; do
    sleep 1
  done

  # Read the content of /shared/streamkey into STREAMKEY variable
  STREAMKEY=$(cat "$STREAMKEY_LOCATION")
  RTMP_URL="rtmp://$RTMP_HOST/app/$STREAMKEY"

  echo "RTMP_URL=\"$RTMP_URL\""

  # Run ffmpeg here (you'll need to replace this with your actual ffmpeg command)
  ffmpeg -i "$RTMP_URL" -rtmp_live live -hls_time 1 -f hls /shared/hls/stream.m3u8

  # Remove the streamkey file
  rm "$STREAMKEY_LOCATION"
done


