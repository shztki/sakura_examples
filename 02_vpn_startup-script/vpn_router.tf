data "http" "ip_address" {
  url = "https://api.ipify.org/"
}

resource "sakuracloud_vpc_router" "vpn_router01" {
  count       = var.vpn_router01["count"]
  zone        = var.zone
  name        = format("%s-%s-%03d", module.label.id, var.vpn_router01["name"], count.index + 1)
  description = var.vpn_router01["memo"]
  version     = var.vpn_router01["version"]
  tags        = concat(var.tags, module.label.attributes)
  plan        = var.vpn_router01["plan"]

  internet_connection = var.vpn_router01["internet_connection"]

  ## premium and above
  #public_network_interface {
  #  switch_id    = sakuracloud_internet.router01[0].switch_id
  #  vip          = sakuracloud_internet.router01[0].ip_addresses[0]
  #  ip_addresses = [sakuracloud_internet.router01[0].ip_addresses[1], sakuracloud_internet.router01[0].ip_addresses[2]]
  #  aliases      = slice(sakuracloud_internet.router01[0].ip_addresses, 3, length(sakuracloud_internet.router01[0].ip_addresses) > 19 ? 22 : length(sakuracloud_internet.router01[0].ip_addresses))
  #  vrid         = var.vpn_router01["vrid"]
  #}

  ## プライベートNICの定義(複数定義可能)
  private_network_interface {
    index     = 1
    switch_id = sakuracloud_switch.switch01.id
    ## premium and above
    #vip          = cidrhost(var.switch01["name"], var.vpn_router01["vip"])
    #ip_addresses = [cidrhost(var.switch01["name"], var.vpn_router01["interface_ip1"]), cidrhost(var.switch01["name"], var.vpn_router01["interface_ip2"])]
    ## standard
    ip_addresses = [cidrhost(var.switch01["name"], var.vpn_router01["vip"] - count.index)]
    netmask      = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
  }
  #private_network_interface {
  #  index     = 2
  #  switch_id = sakuracloud_switch.switch02.id
  #  ## premium and above
  #  #vip          = cidrhost(var.switch02["name"], var.vpn_router01["vip"])
  #  #ip_addresses = [cidrhost(var.switch02["name"], var.vpn_router01["interface_ip1"]), cidrhost(var.switch02["name"], var.vpn_router01["interface_ip2"])]
  #  ## standard
  #  ip_addresses = [cidrhost(var.switch02["name"], var.vpn_router01["vip"] - count.index)]
  #  netmask      = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch02["name"]), 0))
  #}

  ## ポートフォワード
  dynamic "port_forwarding" {
    for_each = range(var.server01["count"])
    content {
      protocol     = "tcp"
      public_port  = 10022 + port_forwarding.key
      private_ip   = cidrhost(var.switch01["name"], var.server01["start_ip"] + port_forwarding.key)
      private_port = 22
      description  = "desc"
    }
  }
  dynamic "port_forwarding" {
    for_each = range(var.server02["count"])
    content {
      protocol     = "tcp"
      public_port  = 10022 + var.server01["count"] + port_forwarding.key
      private_ip   = cidrhost(var.switch01["name"], var.server02["start_ip"] + port_forwarding.key)
      private_port = 22
      description  = "desc"
    }
  }
  dynamic "port_forwarding" {
    for_each = range(var.server03["count"])
    content {
      protocol     = "tcp"
      public_port  = 10022 + var.server01["count"] + var.server02["count"] + port_forwarding.key
      private_ip   = cidrhost(var.switch01["name"], var.server03["start_ip"] + port_forwarding.key)
      private_port = 22
      description  = "desc"
    }
  }
  dynamic "port_forwarding" {
    for_each = range(var.server04["count"])
    content {
      protocol     = "tcp"
      public_port  = 10022 + var.server01["count"] + var.server02["count"] + var.server03["count"] + port_forwarding.key
      private_ip   = cidrhost(var.switch01["name"], var.server04["start_ip"] + port_forwarding.key)
      private_port = 22
      description  = "desc"
    }
  }

  ## スタティックNAT(プレミアム/ハイスペックプランのみ)
  #dynamic "static_nat" {
  #  for_each = range(var.server01["count"])
  #  content {
  #    public_ip   = sakuracloud_internet.router01[0].ip_addresses[3 + static_nat.key]
  #    private_ip  = cidrhost(var.switch01["name"], var.server01["start_ip"] + static_nat.key)
  #    description = format("vpc_nat_%03d", static_nat.key + 1)
  #  }
  #}
  #dynamic "static_nat" {
  #  for_each = range(var.server02["count"])
  #  content {
  #    public_ip   = sakuracloud_internet.router01[0].ip_addresses[3 + static_nat.key + var.server01["count"]]
  #    private_ip  = cidrhost(var.switch01["name"], var.server02["start_ip"] + static_nat.key)
  #    description = format("vpc_nat_%03d", static_nat.key + 1 + var.server01["count"])
  #  }
  #}
  #dynamic "static_nat" {
  #  for_each = range(var.server03["count"])
  #  content {
  #    public_ip   = sakuracloud_internet.router01[0].ip_addresses[3 + static_nat.key + var.server01["count"] + var.server02["count"]]
  #    private_ip  = cidrhost(var.switch01["name"], var.server03["start_ip"] + static_nat.key)
  #    description = format("vpc_nat_%03d", static_nat.key + 1 + var.server01["count"] + var.server02["count"])
  #  }
  #}
  #dynamic "static_nat" {
  #  for_each = range(var.server04["count"])
  #  content {
  #    public_ip   = sakuracloud_internet.router01[0].ip_addresses[3 + static_nat.key + var.server01["count"] + var.server02["count"] + var.server03["count"]]
  #    private_ip  = cidrhost(var.switch01["name"], var.server04["start_ip"] + static_nat.key)
  #    description = format("vpc_nat_%03d", static_nat.key + 1 + var.server01["count"] + var.server02["count"] + var.server03["count"])
  #  }
  #}

  wire_guard {
    ip_address = var.vpn_router01["wire_guard_ip_address"]
    peer {
      name       = var.vpn_router01["peer1_name"]
      ip_address = var.vpn_router01["peer1_ip_address"]
      public_key = var.peer1_public_key
    }
  }

  firewall {
    interface_index = 0

    direction = "receive"
    expression {
      protocol = "tcp"
      source_network      = var.office_cidr
      source_port         = ""
      destination_network = var.switch01["name"]
      destination_port    = "22"
      allow               = true
      logging             = true
      description         = "desc"
    }
    expression {
      protocol = "tcp"
      source_network      = data.http.ip_address.response_body
      source_port         = ""
      destination_network = var.switch01["name"]
      destination_port    = "22"
      allow               = true
      logging             = true
      description         = "desc"
    }
    expression {
      protocol            = "ip"
      source_network      = ""
      source_port         = ""
      destination_network = ""
      destination_port    = ""
      allow               = false
      logging             = true
      description         = "desc"
    }
  }
}

