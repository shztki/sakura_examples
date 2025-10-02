resource "sakuracloud_switch" "switch01" {
  zone        = var.zone
  name        = format("%s-%s", module.label.id, var.switch01["name"])
  description = var.switch01["memo"]
  tags        = concat(var.tags, module.label.attributes)
}

