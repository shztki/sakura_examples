resource "sakuracloud_server" "server01" {
  count            = var.server01["count"]
  zone             = var.zone
  name             = format("%s-%s-%03d", module.label.id, var.server01["name"], count.index + 1)
  disks            = [element(sakuracloud_disk.disk01.*.id, count.index)]
  core             = var.server01["core"]
  memory           = var.server01["memory"]
  commitment       = var.server01["commitment"]
  interface_driver = var.server01["interface_driver"]

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

  user_data = templatefile(var.server01["cloud_init_file"], {
    ssh_authorized_keys = sakuracloud_ssh_key.sshkey01.public_key,
    password            = var.default_password_hash,
    fqdn                = format("%s-%s-%03d", module.label.id, var.server01["name"], count.index + 1),
    if1_name            = "eth0"            # [eth0,ens3]
    connection1_name    = "cloud-init eth0" # [System,cloud-init] [eth0,ens3]
    if2_name            = "eth1"            # [eth1,ens4]
    connection2_name    = "cloud-init eth1" # [System,cloud-init] [eth1,ens4]
    ## private
    nic1ip         = cidrhost(var.switch01["name"], var.server01["start_ip"] + count.index),
    nic1cidr       = element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch01["name"]), 0),
    defaultgateway = cidrhost(var.switch01["name"], var.vpn_router01["vip"]),
    ## router+switch
    #nic1ip         = sakuracloud_internet.router01[0].ip_addresses[count.index],
    #nic1cidr       = var.router01["nw_mask_len"],
    #defaultgateway = sakuracloud_internet.router01[0].gateway,
    dns1       = data.sakuracloud_zone.default.dns_servers[0],
    dns2       = data.sakuracloud_zone.default.dns_servers[1],
    nic2ip     = cidrhost(var.switch02["name"], var.server01["start_ip"] + count.index),
    nic2cidr   = element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch02["name"]), 0),
    vpnnetwork = cidrhost(var.vpn_router01["wire_guard_ip_address"], 0),
    vpncidr    = element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.vpn_router01["wire_guard_ip_address"]), 0),
    vpnnexthop = cidrhost(var.switch02["name"], var.vpn_router01["vip"]),
    vip1       = cidrhost(var.switch01["name"], var.lb01["vip1"]),
  })
  #user_data = join("\n", [
  #  "#cloud-config",
  #  yamlencode({
  #    # --- SSH 公開鍵 ---
  #    ssh_authorized_keys = [sakuracloud_ssh_key.sshkey01.public_key]

  #    # コンソールのためのパスワード設定
  #    password = var.default_password_hash
  #    chpasswd = { expire = false }

  #    # packages フェーズ(update,upgrade を実行すると完了までは時間がかかる)
  #    package_update  = false
  #    package_upgrade = false
  #    packages        = ["nginx", "stress-ng"]

  #    # --- 起動後処理（順序が重要）---
  #    bootcmd = [
  #      # ホスト名設定（cloud-initがlocalhostにするのを上書き）
  #      format("hostnamectl set-hostname %s-%s%03d", module.label.id, var.server01["name"], count.index + 1),

  #      ## 静的IP/DNSを NetworkManager に適用（既存の System eth0 を直接更新）
  #      "nmcli -t -f NAME con show | grep -qx 'System eth0' || nmcli con add type ethernet ifname eth0 con-name 'System eth0'",
  #      format("nmcli con mod 'System eth0' ipv4.addresses '%s/%s' ipv4.gateway '%s' ipv4.dns '%s %s' ipv4.method manual ipv6.method ignore",
  #        cidrhost(var.switch01["name"], var.server01["start_ip"] + count.index),
  #        element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch01["name"]), 0),
  #        cidrhost(var.switch01["name"], var.vpn_router01["vip"]),
  #        data.sakuracloud_zone.default.dns_servers[0],
  #        data.sakuracloud_zone.default.dns_servers[1]
  #      ),
  #      ## 反映（down→up が必要）
  #      "nmcli con down 'System eth0' || true",
  #      "nmcli con up   'System eth0'",

  #      ## 2個めのインターフェース設定
  #      #"nmcli -t -f NAME con show | grep -qx 'System eth1' || nmcli con add type ethernet ifname eth1 con-name 'System eth1'",
  #      #format("nmcli con mod 'System eth1' ipv4.addresses '%s/%s' ipv4.method manual ipv4.never-default yes ipv6.method ignore",
  #      #  cidrhost(var.switch02["name"], var.server01["start_ip"] + count.index),
  #      #  element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch02["name"]), 0)
  #      #),
  #      ## --- System eth1 に永続ルートを追加（次ホップは switch02 の VIP） ---
  #      #format("nmcli con mod 'System eth1' +ipv4.routes '%s/%s %s'",
  #      #  cidrhost(var.vpn_router01["wire_guard_ip_address"], 0),
  #      #  element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.vpn_router01["wire_guard_ip_address"]), 0),
  #      #  cidrhost(var.switch02["name"], var.vpn_router01["vip"])
  #      #),
  #      ## 反映（down→up が必要）
  #      #"nmcli con down 'System eth1' || true",
  #      #"nmcli con up   'System eth1'",

  #      ## DSR: VIP を dummy インターフェースに付与
  #      format("nmcli connection add type dummy ifname vip01 con-name vip01 ipv4.method manual ipv4.addresses '%s/32' ipv6.method ignore",
  #        cidrhost(var.switch01["name"], var.lb01["vip1"])
  #      ),
  #      ## DSR: ARP 抑制を sysctl に設定
  #      "cat > /etc/sysctl.d/99-arp-dsr.conf <<EOF\nnet.ipv4.conf.all.arp_ignore = 1\nnet.ipv4.conf.all.arp_announce = 2\nEOF",
  #      "sysctl --system || sysctl -p || true",

  #      # 少し待つ（DNS/ルート確立）
  #      "sleep 3",
  #    ]

  #    runcmd = [
  #      # NTP設定をさくらインターネットに変更
  #      "grep -q '^server ntp1.sakura.ad.jp iburst' /etc/chrony.conf || echo 'server ntp1.sakura.ad.jp iburst' >> /etc/chrony.conf",
  #      "systemctl restart chronyd",
  #      "chronyc sources || true",

  #      # タイムゾーンを日本に
  #      "timedatectl set-timezone Asia/Tokyo",

  #      # 自動起動
  #      "systemctl enable --now nginx",

  #      # ドキュメントルートへホスト名を書き出し
  #      #    Alma/Rocky どちらでも通るように存在する方へ出力
  #      "DOCROOT=/usr/share/nginx/html; [ -d /var/www/html ] && DOCROOT=/var/www/html",
  #      "hostname > $DOCROOT/index.html"
  #    ]
  #  })
  #])

  description = format("%s%03d", var.server01["memo"], count.index + 1)
  tags        = concat(var.tags, var.server_add_tag, module.label.attributes, [var.group_add_tag[count.index % length(var.group_add_tag)]])
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data]
  }
  #depends_on = [sakuracloud_vpc_router.vpn_router01]
}

