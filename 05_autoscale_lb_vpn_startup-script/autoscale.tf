resource "sakuracloud_auto_scale" "lb_hscale01" {
  name       = format("%s-%s", module.label.id, var.autoscale01["name"])
  zones      = [var.zone]
  api_key_id = var.api_key_id

  trigger_type = var.autoscale01["trigger_type"]
  cpu_threshold_scaling {
    #server_prefix = var.server01["name"]
    server_prefix = format("%s-%s", module.label.id, var.server01["name"])
    up            = var.autoscale01["cpu_up"]
    down          = var.autoscale01["cpu_down"]
  }

  #config = file("yaml/test_ubuntu.yaml")
  config = templatefile(var.autoscale01["file"], {
    zone = var.zone,
    #name                = var.server01["name"],
    name = format("%s-%s", module.label.id, var.server01["name"]),
    #lb_name             = var.lb01["name"],
    lb_name             = format("%s-%s", module.label.id, var.lb01["name"]),
    tags                = concat(var.tags, module.label.attributes),
    switch              = format("%s-%s", module.label.id, var.switch01["name"]),
    assign_cidr_block   = format("%s/%s", cidrhost(var.switch01["name"], var.server01["start_ip"] - 1), element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch01["name"]), 0)),
    assign_netmask_len  = element(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/(\\d+)", var.switch01["name"]), 0),
    os_tags             = local.linux_archives[var.server01["os"]].tags,
    plan                = var.disk01["plan"],
    connector           = var.disk01["connector"],
    size                = var.disk01["size"],
    ssh_authorized_keys = sakuracloud_ssh_key.sshkey01.public_key,
    password            = var.default_password,
    disable_pw_auth     = var.server01["disable_pw_auth"],
    defaultgateway      = cidrhost(var.switch01["name"], var.vpn_router01["vip"]),
    vip1                = cidrhost(var.switch01["name"], var.lb01["vip1"]),
  })

  tags = concat(var.tags, module.label.attributes)

  depends_on = [sakuracloud_load_balancer.lb01]
}

