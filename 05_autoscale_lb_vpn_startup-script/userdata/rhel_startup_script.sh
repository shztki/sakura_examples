#!/bin/bash
# @sacloud-once
# @sacloud-text maxlen=36 user_name "Default USER NAME"
# @sacloud-text maxlen=18 eth1_ip "ETH1 IPADDRESS(*.*.*.*/*)"
# @sacloud-text maxlen=18 route1_prefix1 "ROUTE1 CIDR1(*.*.*.*/*)"
# @sacloud-text maxlen=15 route1_gateway1 "ROUTE1 NEXTHOP1(*.*.*.*)"
# @sacloud-text maxlen=15 loopback_ip "LOOPBACK IPADDRESS(*.*.*.*)"
# @sacloud-radios-begin default=no update "OS UPDATE"
#     yes "yes"
#     no "no"
# @sacloud-radios-end

USER=@@@user_name@@@            # username
ETH1_IP=@@@eth1_ip@@@ 	      	# *.*.*.*/**
ROUTE1_CIDR1=@@@route1_cidr1@@@   # *.*.*.*/**
ROUTE1_NEXTHOP1=@@@route1_nexthop1@@@ # *.*.*.*
LOOPBACK_IP=@@@loopback_ip@@@ 	# *.*.*.*
UPDATE=@@@update@@@ 	      	# yes

#-- 8/9系の OS は通信が可能になるまで少し時間がかかる
if [ $(grep -c "release 8" /etc/redhat-release) -eq 1 ] || [ $(grep -c "release 9" /etc/redhat-release) -eq 1 ] ;then
	sleep 10
else
	exit 0
fi

function create_user() {
  if [ "$USER" == "" ]; then return 0; fi
  id $USER > /dev/null 2>&1 && return 0;
  useradd $USER
  TEST=`cat /etc/shadow | grep root | awk -F':' '{print $2}'`
  sed -i -e "s|^$USER:!!|$USER:$TEST|" /etc/shadow
  mkdir /home/$USER/.ssh
  cp /root/.ssh/authorized_keys /home/$USER/.ssh/
  chown -R $USER:$USER /home/$USER/.ssh/
  chmod 700 /home/$USER/.ssh/
  chmod 600 /home/$USER/.ssh/authorized_keys
  echo "$USER ALL=(ALL) NOPASSWD: ALL"> /etc/sudoers.d/$USER
}
create_user

function setup_eth1() {
  IP=$ETH1_IP
  if [ "$IP" == "" ]; then return 0; fi
  ip a s | grep -q $IP && return 0;
  nmcli con mod "System eth1" \
  ipv4.method manual \
  ipv4.address $IP \
  connection.autoconnect "yes" \
  ipv6.method "disabled"
  if [ "$ROUTE1_CIDR1" != "" ]; then
    nmcli con mod "System eth1" +ipv4.routes "$ROUTE1_CIDR1 $ROUTE1_NEXTHOP1"
  fi
  nmcli con down "System eth1"; nmcli con up "System eth1"
}
setup_eth1

function init_loopback() {
  IP=$LOOPBACK_IP
  if [ "$IP" == "" ]; then return 0; fi
  nmcli connection add type dummy ifname vip01 ipv4.method manual ipv4.addresses $IP/32 ipv6.method ignore
  grep -q "net.ipv4.conf.all.arp_ignore = 1" /etc/sysctl.conf && return 0;
  echo "net.ipv4.conf.all.arp_ignore = 1" >> /etc/sysctl.conf
  echo "net.ipv4.conf.all.arp_announce = 2" >> /etc/sysctl.conf
  sysctl -p
}
init_loopback

function setup_firewalld() {
  #systemctl stop firewalld
  #systemctl disable firewalld
  firewall-cmd --permanent --add-service http
  firewall-cmd --permanent --add-service ssh
  firewall-cmd --reload
}
setup_firewalld

function start_update() {
  if [ "$UPDATE" == "yes" ]; then
    dnf -y update
  fi
}
start_update

function install_httpd() {
    #dnf install -y httpd mod_ssl
    #systemctl enable httpd
    #systemctl start httpd
    #hostname > /var/www/html/index.html
    dnf -y install nginx stress-ng
    systemctl enable nginx
    systemctl start nginx
    hostname > /usr/share/nginx/html/index.html
}
install_httpd

