resource "sakuracloud_disk" "disk01" {
  count                = var.server01["count"]
  zone                 = var.zone
  name                 = format("%s-%s-%03d", module.label.id, var.server01["name"], count.index + 1)
  source_archive_id    = data.sakuracloud_archive.linux_archives[var.server01["os"]].id
  plan                 = var.disk01["plan"]
  encryption_algorithm = var.disk01["encryption_algorithm"]
  connector            = var.disk01["connector"]
  size                 = var.disk01["size"]
  tags                 = concat(var.tags, module.label.attributes)
  description          = format("%s%03d", var.disk01["memo"], count.index + 1)
}
