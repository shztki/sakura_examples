resource "sakuracloud_disk" "disk02" {
  count                = var.server02["count"]
  zone                 = var.zone
  name                 = format("%s-%s-%03d", module.label.id, var.server02["name"], count.index + 1)
  source_archive_id    = data.sakuracloud_archive.linux_cloud_init_archives[var.server02["os"]].id
  plan                 = var.disk02["plan"]
  encryption_algorithm = var.disk02["encryption_algorithm"]
  connector            = var.disk02["connector"]
  size                 = var.disk02["size"]
  tags                 = concat(var.tags, module.label.attributes)
  description          = format("%s%03d", var.disk02["memo"], count.index + 1)
}
