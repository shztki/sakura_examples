data "sakuracloud_archive" "linux_archives" {
  for_each = local.linux_archives

  zone = var.zone

  filter {
    tags = each.value.tags
  }
}

data "sakuracloud_zone" "default" {
  name = var.zone
}

