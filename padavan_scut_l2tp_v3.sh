#!/bin/sh
### Custom user script
### Called after internal VPN client connected/disconnected to remote VPN server
### $1        - action (up/down)
### $IFNAME   - tunnel interface name (e.g. ppp5 or tun0)
### $IPLOCAL  - tunnel local IP address
### $IPREMOTE - tunnel remote IP address
### $DNS1     - peer DNS1
### $DNS2     - peer DNS2
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"
#ip 列表
IP_FILE_URL="https://gitee.com/wykdg/route_script/raw/master/scut_route.txt"
#本地存储路径
IP_FILE="/etc/storage/scut_route.txt"
check_route_file()
{
  if [ ! -f "$IP_FILE" ]; then
    logger -t "【SCUT 加速客户端脚本】" "scut_route.txt不存在，重新下载"
    wget --no-check-certificate $IP_FILE_URL -O $IP_FILE
    logger -t "【SCUT 加速客户端脚本】" "下载scut路由表成功"
  else 
    logger -t "【SCUT 加速客户端脚本】" "scut_route.txt 存在，跳过"
  fi
}
func_ipup()
{
  GATEWAY=`nvram get wan0_gateway`
  logger -t "【SCUT 加速客户端脚本】" "内网IP分流到$GATEWAY网关"
  if [ $GATEWAY == '' ]; then
      logger -t "【SCUT 加速客户端脚本】" "错误！没找到网关"
      exit 0
  fi
  #获取认证服务器的地址
  AUTH_SERVER=`nvram get scutclient_server_auth_ip`
  route add -net $AUTH_SERVER netmask 255.255.255.255 gw $GATEWAY

  #将认证服务器加上
  logger -t "【SCUT 加速客户端脚本】" "设置认证服务器${AUTH_SERVER} 路由成功"

  #以下是教育网内网地址分流
  check_route_file
  cat $IP_FILE|while read -r IP MASK; do
  route add -net $IP netmask $MASK gw $GATEWAY
  done
  logger -t "【SCUT 加速】" "设置路由表成功"
  return 0
}

func_ipdown()
{
  #删除教育网分流
  cat $IP_FILE|while read -r IP MASK; do
  route del -net $IP netmask $MASK
  done
  return 0
}

logger -t "【SCUT 加速客户端脚本】" "$IFNAME $1"

case "$1" in
up)
  func_ipup
  ;;
down)
  func_ipdown
  ;;
esac

