#!/bin/sh
L2TPCMD=/usr/bin/l2tpv3tun
NUM=2

TUN_ID=`uci get network.@tun[$NUM].tunid`
TUN_REMOTE_IP=`uci get network.@tun[$NUM].server|awk -F "/" '{print $1}'`
TUN_NAME=L2
TUN_LOCAL_IP=`uci get network.@ospf[0].id`

$L2TPCMD del session tunnel_id $TUN_ID session_id $TUN_ID
$L2TPCMD del tunnel tunnel_id $TUN_ID

logger "Add l2tp $TUN_NAME tun_id:$TUN_ID remote: $TUN_REMOTE_IP"

$L2TPCMD add tunnel remote $TUN_REMOTE_IP local $TUN_LOCAL_IP tunnel_id $TUN_ID peer_tunnel_id $TUN_ID encap ip
$L2TPCMD add session ifname $TUN_NAME tunnel_id $TUN_ID session_id $TUN_ID peer_session_id $TUN_ID

ifconfig $TUN_NAME mtu 1500  

brctl addif br-lan $TUN_NAME

ifconfig $TUN_NAME up
