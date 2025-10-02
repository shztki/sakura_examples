resource "sakuracloud_server" "server04" {
  count            = var.server04["count"]
  zone             = var.zone
  name             = format("%s-%s-%03d", module.label.id, var.server04["name"], count.index + 1)
  disks            = [element(sakuracloud_disk.disk04.*.id, count.index)]
  core             = var.server04["core"]
  memory           = var.server04["memory"]
  commitment       = var.server04["commitment"]
  interface_driver = var.server04["interface_driver"]

  #network_interface {
  #  upstream = "shared"
  #  #upstream         = sakuracloud_internet.router01[0].switch_id
  #  packet_filter_id = sakuracloud_packet_filter.filter01.id
  #}
  network_interface {
    upstream = sakuracloud_switch.switch01.id
  }
  #network_interface {
  #  upstream = sakuracloud_switch.switch02.id
  #}

  disk_edit_parameter {
    ip_address = cidrhost(var.switch01["name"], var.server04["start_ip"] + count.index)
    gateway    = cidrhost(var.switch01["name"], var.vpn_router01["vip"])
    netmask    = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
    #ip_address      = sakuracloud_internet.router01[0].ip_addresses[3 + var.server01["count"] + var.server02["count"] + var.server03["count"] + count.index]
    #gateway         = sakuracloud_internet.router01[0].gateway
    #netmask         = var.router01["nw_mask_len"]
    hostname        = format("%s-%s-%03d", module.label.id, var.server04["name"], count.index + 1)
    ssh_key_ids     = [sakuracloud_ssh_key.sshkey01.id]
    password        = var.default_password
    disable_pw_auth = var.server04["disable_pw_auth"]
    note {
      id = sakuracloud_note.init_note03.id
      variables = {
        #user_name   = "sakura"
        #eth1_ip     = format("%s/%s", cidrhost(var.switch02["name"], var.server04["start_ip"] + count.index), element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch02["name"]), 0))
        loopback_ip = cidrhost(var.switch01["name"], var.lb01["vip1"])
        #route1_cidr1    = format("%s/%s", cidrhost(var.vpn_router01["wire_guard_ip_address"], 0), element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.vpn_router01["wire_guard_ip_address"]), 0))
        #route1_nexthop1 = cidrhost(var.switch02["name"], var.vpn_router01["vip"])
        #update = "yes"
      }
    }
  }

  description = format("%s%03d", var.server04["memo"], count.index + 1)
  tags        = concat(var.tags, var.server_add_tag, module.label.attributes, [var.group_add_tag[count.index % length(var.group_add_tag)]])

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [disk_edit_parameter]
  }
  #depends_on = [sakuracloud_vpc_router.vpn_router01]
}

