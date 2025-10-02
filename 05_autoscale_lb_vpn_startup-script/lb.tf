resource "sakuracloud_load_balancer" "lb01" {
  network_interface {
    switch_id = sakuracloud_switch.switch01.id
    vrid      = var.lb01["vrid"]
    #ip_addresses = [cidrhost(var.switch01["name"], var.lb01["interface_ip1"]), cidrhost(var.switch01["name"], var.lb01["interface_ip2"])]
    ip_addresses = [cidrhost(var.switch01["name"], var.lb01["interface_ip1"])]
    gateway      = cidrhost(var.switch01["name"], var.vpn_router01["vip"])
    netmask      = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
  }

  plan = var.lb01["plan"]
  name = format("%s-%s", module.label.id, var.lb01["name"])
  #name        = format("%s", var.lb01["name"])
  description = var.lb01["memo"]
  tags        = concat(var.tags, module.label.attributes)

  vip {
    vip          = cidrhost(var.switch01["name"], var.lb01["vip1"])
    port         = 80
    delay_loop   = 10
    sorry_server = var.lb01["sorry_server"]

    dynamic "server" {
      for_each = range(var.server01["start_ip"], var.server01["start_ip"] + var.server01["count"])
      content {
        ip_address = cidrhost(var.switch01["name"], var.server01["start_ip"] + server.key)
        protocol   = "http"
        path       = "/"
        status     = 200
      }
    }
  }
}

