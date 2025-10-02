#!/bin/bash
# @sacloud-once
# @sacloud-text maxlen=36 user_name "Default USER NAME"
# @sacloud-text maxlen=18 eth1_ip "ETH1 IPADDRESS(*.*.*.*/*)"
# @sacloud-text maxlen=18 route1_cidr1 "ROUTE1 CIDR1(*.*.*.*/*)"
# @sacloud-text maxlen=15 route1_nexthop1 "ROUTE1 NEXTHOP1(*.*.*.*)"
# @sacloud-text maxlen=15 loopback_ip "LOOPBACK IPADDRESS(*.*.*.*)"
# @sacloud-radios-begin default=no update "OS UPDATE"
#     yes "yes"
#     no "no"
# @sacloud-radios-end

USER=@@@user_name@@@                  # username
ETH1_IP=@@@eth1_ip@@@ 	      	      # *.*.*.*/**
ROUTE1_CIDR1=@@@route1_cidr1@@@       # *.*.*.*/**
ROUTE1_NEXTHOP1=@@@route1_nexthop1@@@ # *.*.*.*
LOOPBACK_IP=@@@loopback_ip@@@ 	      # *.*.*.*
UPDATE=@@@update@@@ 	      	      # yes

function create_user() {
  if [ "$USER" == "" ]; then return 0; fi
  id $USER > /dev/null 2>&1 && return 0;
  useradd -m $USER
  TEST=`cat /etc/shadow | grep root | awk -F':' '{print $2}'`
  sed -i -e "s|^$USER:!|$USER:$TEST|" /etc/shadow
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
  FILE=/etc/network/interfaces
  if [ "$IP" == "" ]; then return 0; fi
  if [ "$ROUTE1_CIDR1" == "" ]; then
cat <<__EOF__ >> $FILE

auto eth1
iface eth1 inet static
    address $IP

__EOF__
  else
cat <<__EOF__ >> $FILE

auto eth1
iface eth1 inet static
    address $IP
    post-up   ip route add $ROUTE1_CIDR1 via $ROUTE1_NEXTHOP1 dev eth1
    pre-down  ip route del $ROUTE1_CIDR1 via $ROUTE1_NEXTHOP1 dev eth1
__EOF__
  fi

  ifdown eth1
  ifup eth1
}
setup_eth1

function init_loopback() {
  FILE="/etc/network/interfaces"
  IP="$LOOPBACK_IP/32"

  if ! grep -q "$IP" "$FILE"; then
    sed -i "/iface lo inet loopback/a\    up   ip address add $IP dev lo\n    down ip address del $IP dev lo" "$FILE"
  fi

  ifdown lo
  ifup --force lo

  FILE=/etc/sysctl.conf
  echo "net.ipv4.conf.all.arp_ignore = 1" >> $FILE 
  echo "net.ipv4.conf.all.arp_announce = 2" >> $FILE
  sysctl -p
}
init_loopback

function start_update() {
  if [ "$UPDATE" == "yes" ]; then
    apt update
    apt -y upgrade
  fi
}
start_update

function install_httpd() {
  #apt update
  #apt install apache2 -y
  #systemctl enable apache2
  #systemctl start apache2
  #hostname > /var/www/html/index.html
  #a2enmod ssl
  #a2ensite default-ssl
  #systemctl restart apache2
  apt update
  apt install nginx stress-ng -y
  systemctl enable nginx
  systemctl start nginx
  hostname > /var/www/html/index.html
}
install_httpd

