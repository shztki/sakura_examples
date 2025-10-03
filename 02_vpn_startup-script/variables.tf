variable "zone" {
  default = "tk1b"
}

variable "default_password" {}
variable "office_cidr" {}
variable "peer1_public_key" {}

variable "label" {
  default = {
    namespace = "yourname"
    stage     = "dev"
    name      = "startup-script"
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
    encryption_algorithm = "none" # none/aes256_xts
    memo                 = "example"
  }
}

variable "disk02" {
  default = {
    size                 = 20    # min win:100 / linux:20
    plan                 = "ssd" # ssd or hdd
    connector            = "virtio"
    encryption_algorithm = "none" # none/aes256_xts
    memo                 = "example"
  }
}

variable "disk03" {
  default = {
    size                 = 20    # min win:100 / linux:20
    plan                 = "ssd" # ssd or hdd
    connector            = "virtio"
    encryption_algorithm = "none" # none/aes256_xts
    memo                 = "example"
  }
}

variable "disk04" {
  default = {
    size                 = 20    # min win:100 / linux:20
    plan                 = "ssd" # ssd or hdd
    connector            = "virtio"
    encryption_algorithm = "none" # none/aes256_xts
    memo                 = "example"
  }
}

variable "server01" {
  default = {
    os               = "almalinux_9_latest"
    count            = 1
    core             = 2
    memory           = 4
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "alma"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 10
  }
}

variable "server02" {
  default = {
    os               = "rockylinux_9_latest"
    count            = 1
    core             = 2
    memory           = 4
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "rocky"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 20
  }
}

variable "server03" {
  default = {
    os               = "ubuntu_24_04_latest"
    count            = 1
    core             = 2
    memory           = 4
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "ubuntu"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 30
  }
}

variable "server04" {
  default = {
    os               = "debian_12_latest"
    count            = 1
    core             = 2
    memory           = 4
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "debian"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 40
  }
}

variable "init_script01" {
  default = {
    name  = "rhel_init"
    class = "shell" # shell or yaml_cloud_config
    file  = "userdata/rhel_startup_script.sh"
  }
}

variable "init_script02" {
  default = {
    name  = "ubuntu_init"
    class = "shell" # shell or yaml_cloud_config
    file  = "userdata/ubuntu_startup_script.sh"
  }
}

variable "init_script03" {
  default = {
    name  = "debian_init"
    class = "shell" # shell or yaml_cloud_config
    file  = "userdata/debian_startup_script.sh"
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
    vrid                  = 1
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
