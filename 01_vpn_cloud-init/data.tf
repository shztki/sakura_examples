data "sakuracloud_archive" "linux_cloud_init_archives" {
  for_each = local.linux_cloud_init_archives

  zone = var.zone

  filter {
    tags = each.value.tags
  }
}

data "sakuracloud_zone" "default" {
  name = var.zone
}

