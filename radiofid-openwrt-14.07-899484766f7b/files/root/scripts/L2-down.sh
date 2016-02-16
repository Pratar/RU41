#!/bin/sh
L2TPCMD=/usr/bin/l2tpv3tun
NUM=2

TUN_ID=`uci get network.@tun[$NUM].tunid`
TUN_REMOTE_IP=`uci get network.@tun[$NUM].server|awk -F "/" '{print $1}'`
TUN_NAME=L2
TUN_LOCAL_IP=`uci get network.@ospf[0].id`

logger "Remove l2tp $TUN_NAME tun_id:$TUN_ID remote: $TUN_REMOTE_IP"

$L2TPCMD del session tunnel_id $TUN_ID session_id $TUN_ID
$L2TPCMD del tunnel tunnel_id $TUN_ID

