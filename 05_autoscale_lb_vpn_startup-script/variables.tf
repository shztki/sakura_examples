variable "zone" {
  default = "tk1b"
}

variable "default_password" {}
variable "office_cidr" {}
variable "peer1_public_key" {}
variable "api_key_id" {}

variable "label" {
  default = {
    namespace = "yourname"
    stage     = "dev"
    name      = "autoscale-lb"
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

variable "server01" {
  default = {
    os = "almalinux_9_latest"
    #os = "ubuntu_24_04_latest"
    #os               = "debian_12_latest"
    count            = 2
    core             = 2
    memory           = 4
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "web-servers"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 10
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

variable "vpn_router01" {
  default = {
    count                 = 1
    name                  = "vpn"
    memo                  = "example"
    version               = 2
    plan                  = "standard"
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
    name          = "scaleout-lb"
    memo          = "example"
    plan          = "standard" # standard or highspec
    vrid          = 250
    sorry_server  = ""
    vip1          = 250
    interface_ip1 = 249
    interface_ip2 = 248
  }
}

variable "autoscale01" {
  default = {
    name         = "scaleout"
    trigger_type = "cpu"
    cpu_up       = 77
    cpu_down     = 30
    file         = "yaml/lb_out_rhel.yaml"
    #file = "yaml/lb_out_ubuntu.yaml"
    #file = "yaml/lb_out_debian.yaml"
    memo = "example"
  }
}

