#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"
#本地存储路径
IP_FILE="/usr/share/scut_uniom/scut_route.txt"
GATEWAY=`uci get network.wan.gateway`
#以下是教育网内网地址分流
cat $IP_FILE|while read -r IP MASK; do
route add -net $IP netmask $MASK gw $GATEWAY dev eth1
done
return 0

