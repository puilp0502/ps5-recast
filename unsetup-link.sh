#!/bin/bash
source ./config.env

DEV_IP=$(ip -f inet addr show $DEV | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
sudo ip addr del $DEV_IP/24 dev $DEV

sudo sysctl -w net.ipv4.ip_forward=0

for RANGE in $IP_RANGES; do
	sudo iptables -t nat -D PREROUTING -d $RANGE -p tcp --dport 1935 -j DNAT --to-destination $DEVADDR:1935
done

sudo iptable -D FORWARD -j ACCEPT
sudo iptables -t nat -D POSTROUTING -o $OUTDEV -j MASQUERADE


