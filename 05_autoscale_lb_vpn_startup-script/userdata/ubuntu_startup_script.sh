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
  if [ "$USER" == "" ]; then USER=ubuntu; fi
  if [ "$USER" != "ubuntu" ]; then
    id $USER > /dev/null 2>&1 && return 0;
    useradd -m $USER
    TEST=`cat /etc/shadow | grep ubuntu | awk -F':' '{print $2}'`
    sed -i -e "s|^$USER:!|$USER:$TEST|" /etc/shadow
    mkdir /home/$USER/.ssh
    cp /home/ubuntu/.ssh/authorized_keys /home/$USER/.ssh/
    chown -R $USER:$USER /home/$USER/.ssh/
    chmod 700 /home/$USER/.ssh/
    chmod 600 /home/$USER/.ssh/authorized_keys
  fi
  echo "$USER ALL=(ALL) NOPASSWD: ALL"> /etc/sudoers.d/$USER
}
create_user

function setup_eth1() {
  IP=$ETH1_IP
  FILE=/etc/netplan/02-netcfg.yaml
  if [ "$IP" == "" ]; then return 0; fi
  if [ -f $FILE ]; then
    return 0;
  fi
  if [ "$ROUTE1_CIDR1" == "" ]; then
cat <<__EOF__ >> $FILE
network:
  ethernets:
    eth1:
      addresses:
        - $IP
      dhcp4: 'no'
      dhcp6: 'no'
  renderer: networkd
  version: 2
__EOF__
  else
cat <<__EOF__ >> $FILE
network:
  ethernets:
    eth1:
      addresses:
        - $IP
      routes:
        - to: $ROUTE1_CIDR1
          via: $ROUTE1_NEXTHOP1
      dhcp4: 'no'
      dhcp6: 'no'
  renderer: networkd
  version: 2
__EOF__
  fi

  chmod 600 $FILE
  netplan apply
}
setup_eth1

function init_loopback() {
  IP=$LOOPBACK_IP
  FILE=/etc/netplan/lo-netcfg.yaml
  if [ "$IP" == "" ]; then return 0; fi
  if [ -f $FILE ]; then
    return 0;
  fi
cat <<__EOF__ >> $FILE
network:
  version: 2
  renderer: networkd
  ethernets:
    lo:
      match:
        name: lo
      addresses: [ $IP/32 ]
__EOF__
  chmod 600 $FILE
  netplan apply

  FILE=/etc/sysctl.d/99-loopback.conf
  if [ -f $FILE ]; then
    return 0;
  fi
  echo "net.ipv4.conf.all.arp_ignore = 1" > $FILE 
  echo "net.ipv4.conf.all.arp_announce = 2" >> $FILE
  sysctl -p
}
init_loopback

function setup_firewalld() {
  #ufw disable
  ufw allow http
  ufw allow ssh
  ufw reload
}
setup_firewalld

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

