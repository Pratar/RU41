#!/bin/sh
for tun in `uci show network|grep sim|grep enable|awk -F "." '{print $2}'|awk -F "=" '{print $1}'` 
do
	ifstatus $tun | grep csq | cut -d\" -f4
done

