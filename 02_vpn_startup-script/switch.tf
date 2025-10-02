resource "sakuracloud_switch" "switch01" {
  zone        = var.zone
  name        = format("%s-%s", module.label.id, var.switch01["name"])
  description = var.switch01["memo"]
  tags        = concat(var.tags, module.label.attributes)
}

#resource "sakuracloud_switch" "switch02" {
#  zone        = var.zone
#  name        = format("%s-%s", module.label.id, var.switch02["name"])
#  description = var.switch02["memo"]
#  tags        = concat(var.tags, module.label.attributes)
#}

