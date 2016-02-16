#!/bin/sh

# ospf
uci set network.@ospf[0].id=10.48.50.1 
uci set network.@ospf[0].area=0.0.0.1
uci set network.@ospf[0].network=10.48.50.128/29

# Megafone
uci set network.@tun[0].server=10.48.31.245/32
uci set network.@tun[0].local=10.48.50.134/30
uci set network.@tun[0].tunid=10
uci set network.@tun[0].sessid=10
uci set network.@tun[0].cost=33

# Beeline
uci set network.@tun[1].server=10.48.15.250/32
uci set network.@tun[1].local=10.48.50.130/30
uci set network.@tun[1].tunid=11
uci set network.@tun[1].sessid=11
uci set network.@tun[1].cost=10

# L2 
uci set network.@tun[2].server=192.168.0.101/32
uci set network.@tun[2].tunid=12
uci set network.@tun[2].sessid=12

uci commit network
/etc/init.d/network restart
