#!/bin/sh

NUM=0

cp /root/scripts/main.ospf /tmp/ospfd.tmp

for tun in `uci show network|grep sim|grep enable|awk -F "." '{print $2}'|awk -F "=" '{print $1}'`
do
  cp /root/scripts/if.ospf /tmp/$tun.tmp

  if [ $tun = "sim2" ]; then
      NUM=1
  fi

  sed -i /tmp/$tun.tmp \
  -e s/CC/`uci get network.@tun[$NUM].cost`/g \
  -e s/II/`uci get network.@ospf[0].hello`/g \
  -e s/DD/`uci get network.@ospf[0].dead`/g \
  -e s/TT/`uci get network.@ospf[0].delay`/g \
  -e s/eth-SIM/eth-$tun/g

  cat /tmp/$tun.tmp >> /tmp/ospfd.tmp
  rm /tmp/$tun.tmp  
done

cp /root/scripts/router.ospf /tmp/router.tmp

sed -i /tmp/router.tmp \
 -e s/II/`uci get network.@ospf[0].id`/g \
 -e s/AA/`uci get network.@ospf[0].area`/g \
 -e s:NN:`uci get network.@ospf[0].network`\:g

cat /tmp/router.tmp >> /tmp/ospfd.tmp 

rm /tmp/router.tmp

cat /tmp/ospfd.tmp > /etc/quagga/ospfd.conf

rm /tmp/ospfd.tmp

/etc/init.d/quagga restart

