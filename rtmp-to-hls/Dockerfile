FROM debian:bookworm

RUN apt-get update && apt-get -y install ffmpeg

COPY entrypoint.sh /root

ENTRYPOINT ["/root/entrypoint.sh"]

