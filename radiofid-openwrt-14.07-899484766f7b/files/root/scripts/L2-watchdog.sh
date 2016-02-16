#!/bin/sh

DEV=L2
POINT=`uci get network.@ospf[0].id`
DEST=`uci get network.@tun[2].server|awk -F "/" '{print $1}'`

if ip link show $DEV | grep -q "UP"  
   then
	tries=0
	while [[ $tries -lt 15 ]]
	do
		if /bin/ping -c 1 -I $POINT $DEST >/dev/null  
		then
			exit 0
		fi
		tries=$((tries+1))
	done
fi

logger "Restart L2 tunnel from: $POINT to: $DEST"
/root/scripts/L2-down.sh
/root/scripts/L2-up.sh
