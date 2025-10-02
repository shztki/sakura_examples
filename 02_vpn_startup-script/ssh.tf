resource "sakuracloud_ssh_key" "sshkey01" {
  name       = format("%s-%s", module.label.id, var.sshkey01["name"])
  public_key = file("~/.ssh/id_rsa.pub")
}
