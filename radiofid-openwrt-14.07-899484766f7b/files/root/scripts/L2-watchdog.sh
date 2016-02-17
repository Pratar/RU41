#!/bin/sh

DEV=L2
POINT=`uci get network.@ospf[0].id`
DEST=`uci get network.@tun[2].server|awk -F "/" '{print $1}'`

[ -f /tmp/wdog.txt ] || {
  echo '3' > /tmp/wdog.txt
}

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
	wdog=`expr $wdog - 1`;
	echo $wdog > /tmp/wdog.txt
fi

wdog=`cat /tmp/wdog.txt`
[ $wdog -le 0 ] && {
  logger "Reboot planned"
  [ `cat /proc/uptime | awk -F . '{ print $1 }'` -gt 3600 ] && {
    reboot
  }
}

logger "Restart L2 tunnel from: $POINT to: $DEST"
/root/scripts/L2-down.sh
/root/scripts/L2-up.sh
