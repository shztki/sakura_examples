#data "http" "ip_address" {
#  url = "https://api.ipify.org/"
#}

resource "sakuracloud_vpc_router" "vpn_router01" {
  count       = var.vpn_router01["count"]
  zone        = var.zone
  name        = format("%s-%s-%03d", module.label.id, var.vpn_router01["name"], count.index + 1)
  description = var.vpn_router01["memo"]
  version     = var.vpn_router01["version"]
  tags        = concat(var.tags, module.label.attributes)
  plan        = var.vpn_router01["plan"]

  internet_connection = var.vpn_router01["internet_connection"]

  ## プライベートNICの定義(複数定義可能)
  private_network_interface {
    index        = 1
    switch_id    = sakuracloud_switch.switch01.id
    ip_addresses = [cidrhost(var.switch01["name"], var.vpn_router01["vip"] - count.index)]
    netmask      = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
  }

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
  port_forwarding {
    protocol     = "tcp"
    public_port  = 80
    private_ip   = cidrhost(var.switch01["name"], var.lb01["vip1"])
    private_port = 80
    description  = "desc"
  }

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
      #source_network = data.http.ip_address.response_body
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
      #source_network = data.http.ip_address.response_body
      source_network      = var.office_cidr
      source_port         = ""
      destination_network = var.switch01["name"]
      destination_port    = "80"
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

