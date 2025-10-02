data "sakuracloud_archive" "windows_archives" {
  for_each = local.windows_archives

  zone = var.zone

  filter {
    names = each.value.names
  }
}

data "sakuracloud_zone" "default" {
  name = var.zone
}

