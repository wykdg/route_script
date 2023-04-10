#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"




#本地存储路径
if=`uci get network.unicom`
if [ ! -n "$if" ]; then 
    echo "create l2tp" 
    uci set network.unicom=interface
    uci set network.unicom.proto='l2tp'
    uci set network.unicom.ipv6='auto'
    uci set firewall.@zone[1].network='wan wan6 unicom'
fi 
    
uci set network.unicom.server=$1
uci set network.unicom.username=$2
uci set network.unicom.password=$3
uci commit

ifup unicom

IP_FILE="/usr/share/scut_unicom/scut_route.txt"
GATEWAY=`uci get network.wan.gateway`
#以下是教育网内网地址分流
cat $IP_FILE|while read -r IP MASK; do
route add -net $IP netmask $MASK gw $GATEWAY dev eth1
done
return 0

