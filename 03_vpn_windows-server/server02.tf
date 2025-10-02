resource "sakuracloud_server" "server02" {
  count            = var.server02["count"]
  zone             = var.zone
  name             = format("%s-%s-%03d", module.label.id, var.server02["name"], count.index + 1)
  disks            = [element(sakuracloud_disk.disk02.*.id, count.index)]
  core             = var.server02["core"]
  memory           = var.server02["memory"]
  commitment       = var.server02["commitment"]
  interface_driver = var.server02["interface_driver"]

  network_interface {
    upstream = sakuracloud_switch.switch01.id
  }

  disk_edit_parameter {
    ip_address = cidrhost(var.switch01["name"], var.server02["start_ip"] + count.index)
    gateway    = cidrhost(var.switch01["name"], var.vpn_router01["vip"])
    netmask    = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
  }

  description = format("%s%03d", var.server02["memo"], count.index + 1)
  tags        = concat(var.tags, var.server_add_tag, module.label.attributes, [var.group_add_tag[count.index % length(var.group_add_tag)]])
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [disk_edit_parameter]
  }
  #depends_on = [sakuracloud_vpc_router.vpn_router01]
}

