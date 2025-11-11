resource "sakuracloud_kms" "kms01" {
  name        = format("%s-%s", module.label.id, var.kms01["name"])
  description = var.kms01["memo"]
  tags        = concat(var.tags, module.label.attributes)
}

