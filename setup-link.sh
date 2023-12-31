#!/bin/bash

source ./config.env

DEV_IP=$(ip -f inet addr show $DEV | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
if [[ "$DEV_IP" == "" ]]; then
	echo "ip not set; setting to $DEVADDR/24"
	sudo ip addr add $DEVADDR/24 dev $DEV
else
	echo "IP already set ($DEV_IP)"
fi

# Enable portforwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Hijack TCP Traffic to Twitch PoP IP ranges to local interface
for RANGE in $IP_RANGES; do
	sudo iptables -t nat -A PREROUTING -d $RANGE -p tcp --dport 1935 -j DNAT --to-destination $DEVADDR:1935
done

# If the machine has docker installed, the FORWARD chain is intercepted by 
# DOCKER-USER and DOCKER chain first; This prevents iptables from accessing internet
# Prevent this by inserting ACCEPT rule at the start of FORWARD chain
sudo iptables -I FORWARD -j ACCEPT

# Enable NAT
sudo iptables -t nat -A POSTROUTING -o $OUTDEV -j MASQUERADE

