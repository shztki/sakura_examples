resource "sakuracloud_note" "init_note01" {
  name    = format("%s-%s", module.label.id, var.init_script01["name"])
  class   = var.init_script01["class"]
  content = file(var.init_script01["file"])
  tags    = concat(var.tags, module.label.attributes)
}

resource "sakuracloud_note" "init_note02" {
  name    = format("%s-%s", module.label.id, var.init_script02["name"])
  class   = var.init_script02["class"]
  content = file(var.init_script02["file"])
  tags    = concat(var.tags, module.label.attributes)
}

resource "sakuracloud_note" "init_note03" {
  name    = format("%s-%s", module.label.id, var.init_script03["name"])
  class   = var.init_script03["class"]
  content = file(var.init_script03["file"])
  tags    = concat(var.tags, module.label.attributes)
}

