variable "zone" {
  default = "is1c"
}

variable "default_password_hash" {}
variable "office_cidr" {}
variable "peer1_public_key" {}

variable "label" {
  default = {
    namespace = "yourname"
    stage     = "dev"
    name      = "cloud-init"
  }
}

variable "server_add_tag" {
  default = ["@auto-reboot"]
}

variable "group_add_tag" {
  default = ["@group=a", "@group=b", "@group=c", "@group=d"]
}

variable "tags" {
  default = ["@Instant"]
  #default = ["@Normal", "Del20251001"]
}

variable "sshkey01" {
  default = {
    name = "sshkey01"
    memo = "example"
  }
}

variable "disk01" {
  default = {
    size                 = 20    # min win:100 / linux:20
    plan                 = "ssd" # ssd or hdd
    connector            = "virtio"
    encryption_algorithm = "aes256_xts" # none/aes256_xts
    memo                 = "example"
  }
}

variable "disk02" {
  default = {
    size                 = 20    # min win:100 / linux:20
    plan                 = "ssd" # ssd or hdd
    connector            = "virtio"
    encryption_algorithm = "aes256_xts" # none/aes256_xts
    memo                 = "example"
  }
}

variable "disk03" {
  default = {
    size                 = 20    # min win:100 / linux:20
    plan                 = "ssd" # ssd or hdd
    connector            = "virtio"
    encryption_algorithm = "aes256_xts" # none/aes256_xts
    memo                 = "example"
  }
}

variable "disk04" {
  default = {
    size                 = 20    # min win:100 / linux:20
    plan                 = "ssd" # ssd or hdd
    connector            = "virtio"
    encryption_algorithm = "aes256_xts" # none/aes256_xts
    memo                 = "example"
  }
}

variable "server01" {
  default = {
    os               = "alma_10_0"
    count            = 1
    core             = 2
    memory           = 4
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "alma"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 10
    cloud_init_file  = "userdata/rhel_cloud_init.yaml"
  }
}

variable "server02" {
  default = {
    os               = "rocky_10_0"
    count            = 1
    core             = 2
    memory           = 4
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "rocky"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 20
    cloud_init_file  = "userdata/rhel_cloud_init.yaml"
  }
}

variable "server03" {
  default = {
    os               = "ubuntu_24_04_2"
    count            = 1
    core             = 2
    memory           = 4
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "ubuntu"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 30
    cloud_init_file  = "userdata/ubuntu_cloud_init.yaml"
  }
}

variable "server04" {
  default = {
    os               = "debian_12_7_0"
    count            = 1
    core             = 2
    memory           = 4
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "debian"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 40
    cloud_init_file  = "userdata/ubuntu_cloud_init.yaml"
  }
}

variable "switch01" {
  default = {
    name = "192.168.10.0/24"
    memo = "example"
  }
}

variable "switch02" {
  default = {
    name = "192.168.11.0/24"
    memo = "example"
  }
}

variable "vpn_router01" {
  default = {
    count   = 1
    name    = "vpn"
    memo    = "example"
    version = 2
    plan    = "standard" # premium(Required router+switch)/standard
    #plan                  = "premium" # premium(Required router+switch)/standard
    internet_connection   = true
    vip                   = 254
    interface_ip1         = 253
    interface_ip2         = 252
    vrid                  = 254
    wire_guard_ip_address = "192.168.31.1/24"
    peer1_name            = "mypc"
    peer1_ip_address      = "192.168.31.11"
  }
}

variable "lb01" {
  default = {
    vip1 = 250
  }
}

variable "router01" {
  default = {
    count       = 0
    name        = "router"
    nw_mask_len = 28
    band_width  = 100
    enable_ipv6 = false
    memo        = "example"
  }
}

variable "filter01" {
  default = {
    name = "app-filter"
    memo = "example"
  }
}

variable "kms01" {
  default = {
    name = "kms"
    memo = "example"
  }
}

