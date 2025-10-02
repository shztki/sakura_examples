resource "sakuracloud_disk" "disk04" {
  count                = var.server04["count"]
  zone                 = var.zone
  name                 = format("%s-%s-%03d", module.label.id, var.server04["name"], count.index + 1)
  source_archive_id    = data.sakuracloud_archive.linux_cloud_init_archives[var.server04["os"]].id
  plan                 = var.disk04["plan"]
  encryption_algorithm = var.disk04["encryption_algorithm"]
  connector            = var.disk04["connector"]
  size                 = var.disk04["size"]
  tags                 = concat(var.tags, module.label.attributes)
  description          = format("%s%03d", var.disk04["memo"], count.index + 1)
}
