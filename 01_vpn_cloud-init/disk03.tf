resource "sakuracloud_disk" "disk03" {
  count                = var.server03["count"]
  zone                 = var.zone
  name                 = format("%s-%s-%03d", module.label.id, var.server03["name"], count.index + 1)
  source_archive_id    = data.sakuracloud_archive.linux_cloud_init_archives[var.server03["os"]].id
  plan                 = var.disk03["plan"]
  encryption_algorithm = var.disk03["encryption_algorithm"]
  connector            = var.disk03["connector"]
  size                 = var.disk03["size"]
  tags                 = concat(var.tags, module.label.attributes)
  description          = format("%s%03d", var.disk03["memo"], count.index + 1)
}
