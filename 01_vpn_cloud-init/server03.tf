resource "sakuracloud_server" "server03" {
  count            = var.server03["count"]
  zone             = var.zone
  name             = format("%s-%s-%03d", module.label.id, var.server03["name"], count.index + 1)
  disks            = [element(sakuracloud_disk.disk03.*.id, count.index)]
  core             = var.server03["core"]
  memory           = var.server03["memory"]
  commitment       = var.server03["commitment"]
  interface_driver = var.server03["interface_driver"]

  #network_interface {
  #  upstream         = "shared"
  #  #upstream         = sakuracloud_internet.router01[0].switch_id
  #  packet_filter_id = sakuracloud_packet_filter.filter01.id
  #}
  network_interface {
    upstream = sakuracloud_switch.switch01.id
  }
  #network_interface {
  #  upstream = sakuracloud_switch.switch02.id
  #}

  user_data = templatefile(var.server03["cloud_init_file"], {
    ssh_authorized_keys = sakuracloud_ssh_key.sshkey01.public_key,
    password            = var.default_password_hash,
    fqdn                = format("%s-%s-%03d", module.label.id, var.server03["name"], count.index + 1),
    ## private
    nic1ip         = cidrhost(var.switch01["name"], var.server03["start_ip"] + count.index),
    nic1cidr       = element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch01["name"]), 0),
    defaultgateway = cidrhost(var.switch01["name"], var.vpn_router01["vip"]),
    ## router+switch
    #nic1ip         = sakuracloud_internet.router01[0].ip_addresses[var.server01["count"] + var.server02["count"] + count.index],
    #nic1cidr       = var.router01["nw_mask_len"],
    #defaultgateway = sakuracloud_internet.router01[0].gateway,
    dns1       = data.sakuracloud_zone.default.dns_servers[0],
    dns2       = data.sakuracloud_zone.default.dns_servers[1],
    nic2ip     = cidrhost(var.switch02["name"], var.server03["start_ip"] + count.index),
    nic2cidr   = element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch02["name"]), 0),
    vpnnetwork = cidrhost(var.vpn_router01["wire_guard_ip_address"], 0),
    vpncidr    = element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.vpn_router01["wire_guard_ip_address"]), 0),
    vpnnexthop = cidrhost(var.switch02["name"], var.vpn_router01["vip"]),
    vip1       = cidrhost(var.switch01["name"], var.lb01["vip1"]),
  })
  #user_data = join("\n", [
  #  "#cloud-config",
  #  yamlencode({
  #    # ホスト名上書き防止
  #    hostname          = format("%s-%s%03d", module.label.id, var.server03["name"], count.index + 1)
  #    fqdn              = format("%s-%s%03d.local", module.label.id, var.server03["name"], count.index + 1)
  #    preserve_hostname = false

  #    # SSH 公開鍵
  #    ssh_authorized_keys = [sakuracloud_ssh_key.sshkey01.public_key]

  #    # コンソール用パスワード（ハッシュ文字列OK）
  #    password = var.default_password_hash
  #    chpasswd = { expire = false }

  #    # apt パッケージ導入
  #    package_update  = false
  #    package_upgrade = false
  #    packages        = ["nginx", "stress-ng"]

  #    bootcmd = [
  #      ## netplan を 99-netcfg.yaml に生成（50-cloud-init.yaml は残す）
  #      format("cat > /etc/netplan/99-netcfg.yaml <<'NETCFG'\nnetwork:\n  version: 2\n  ethernets:\n    ens3:\n      dhcp4: false\n      dhcp6: false\n      addresses: [\"%s/%s\"]\n      nameservers:\n        addresses: [%s, %s]\n      routes:\n        - to: default\n          via: %s\nNETCFG",
  #        cidrhost(var.switch01["name"], var.server03["start_ip"] + count.index),
  #        element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch01["name"]), 0),
  #        data.sakuracloud_zone.default.dns_servers[0],
  #        data.sakuracloud_zone.default.dns_servers[1],
  #        cidrhost(var.switch01["name"], var.vpn_router01["vip"])
  #      ),

  #      ## --- 92: ens4 (private) ※GW/DNSなし（必要なら追記） ---
  #      #format("cat > /etc/netplan/92-ens4.yaml <<'NETCFG'\nnetwork:\n  version: 2\n  ethernets:\n    ens4:\n      dhcp4: false\n      dhcp6: false\n      addresses: [\"%s/%s\"]\nNETCFG",
  #      #  cidrhost(var.switch02["name"], var.server03["start_ip"] + count.index),
  #      #  element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch02["name"]), 0)
  #      #),
  #      ## --- 92: ens4 (private) ※GW/DNSなし（静的ルートのみ付与） ---
  #      #format("cat > /etc/netplan/92-ens4.yaml <<'NETCFG'\nnetwork:\n  version: 2\n  ethernets:\n    ens4:\n      dhcp4: false\n      dhcp6: false\n      addresses: [\"%s/%s\"]\n      routes:\n        - to: %s/%s\n          via: %s\nNETCFG",
  #      #  cidrhost(var.switch02["name"], var.server03["start_ip"] + count.index),                            # ens4のアドレス
  #      #  element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch02["name"]), 0),                      # ens4のプレフィクス
  #      #  cidrhost(var.vpn_router01["wire_guard_ip_address"], 0),                                            # 宛先ネットワーク(192.168.31.0)
  #      #  element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.vpn_router01["wire_guard_ip_address"]), 0), # 宛先プレフィクス(24)
  #      #  cidrhost(var.switch02["name"], var.vpn_router01["vip"])                                            # 次ホップ(GW)
  #      #),

  #      ## --- 91: VIP on lo (/32) ---
  #      format("cat > /etc/netplan/91-vip.yaml <<'NETCFG'\nnetwork:\n  version: 2\n  ethernets:\n    lo:\n      match:\n        name: lo\n      addresses: [\"%s/32\"]\nNETCFG",
  #        cidrhost(var.switch01["name"], var.lb01["vip1"])
  #      ),
  #      ## DSR: ARP 抑制を sysctl に設定
  #      "cat > /etc/sysctl.d/99-loopback.conf <<EOF\nnet.ipv4.conf.all.arp_ignore = 1\nnet.ipv4.conf.all.arp_announce = 2\nEOF",
  #      "sysctl --system || sysctl -p || true",

  #      # netplan 反映
  #      "netplan apply",
  #      "sleep 3"
  #    ]

  #    runcmd = [
  #      # NTP (systemd-timesyncd)
  #      "sed -i '/^#\\?NTP=/d' /etc/systemd/timesyncd.conf",
  #      "printf 'NTP=ntp1.sakura.ad.jp\\n' >> /etc/systemd/timesyncd.conf",
  #      "systemctl restart systemd-timesyncd.service || true",
  #      "timedatectl set-ntp true",

  #      # タイムゾーン
  #      "timedatectl set-timezone Asia/Tokyo",

  #      # nginx 自動起動
  #      "systemctl enable --now nginx || true",

  #      # index.html にホスト名を書き出し
  #      "DOCROOT=/var/www/html",
  #      "hostname > \"$DOCROOT/index.html\""
  #    ]
  #  })
  #])

  description = format("%s%03d", var.server03["memo"], count.index + 1)
  tags        = concat(var.tags, var.server_add_tag, module.label.attributes, [var.group_add_tag[count.index % length(var.group_add_tag)]])

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
  #depends_on = [sakuracloud_vpc_router.vpn_router01]
}

