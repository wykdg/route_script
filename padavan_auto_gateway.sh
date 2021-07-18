
#!/bin/sh

#本脚本用于padavan主路由，通过判断旁路由是否在线，来更新网关
#遗憾的是dhcp没找到强制更新，更新网关还需要设备重新联网
#用参考了别人的脚本，但是那个需要手动修改dnsmaqs.conf，这里用padavan自身的配置命令nvram和rc事件来更新，更简洁
###然后放到crontab里，每分钟检测一次
# * * * * * /etc/storage/bin/auto_gateway.sh

bypass=192.168.123.2 
default_ip=192.168.123.1
 
network()
{
	#通过判断路由器的页面能否打开判断旁路由在不在线
    local timeout=2
	#call bypass server
	local ret_code=`curl -I -s -m ${timeout} ${bypass} -w %{http_code} | tail -n1`
	if [ "x$ret_code" = "x200" ]; then
		return 1
	else
		return 0
	fi
}
 
changeGateway()
{
	#c获取当前的网关配置
	local current_gate_way=`nvram get dhcp_gateway_x` 
	if [ $current_gate_way = $1 ];then #如果相等就不用改了,
		# /usr/bin/logger "[bypass detect] gateway don't need to change"
		return 0
	else
		nvram set dhcp_gateway_x=$1 #修改网关和dns，然后重启dhcpd服务
		nvram set dhcp_dns1_x=$1 
		nvram commit
		restart_dhcpd
		/usr/bin/logger "[bypass detect] change gateway to $1 success"
		return 0
	fi
}
 
network
if [ $? -eq 0 ];then
	changeGateway $default_ip
else
	changeGateway $bypass
fi
