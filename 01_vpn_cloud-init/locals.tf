locals {
  linux_cloud_init_archives = {
    ubuntu_22_04_5 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-ubuntu",
        "distro-ver-22.04.5"
      ]
    }
    ubuntu_24_04_1 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-ubuntu",
        "distro-ver-24.04.1"
      ]
    }
    ubuntu_24_04_2 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-ubuntu",
        "distro-ver-24.04.2"
      ]
    }

    alma_8_9 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-alma",
        "distro-ver-8.9"
      ]
    }
    alma_8_10 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-alma",
        "distro-ver-8.10"
      ]
    }
    alma_9_5 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-alma",
        "distro-ver-9.5"
      ]
    }
    alma_9_6 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-alma",
        "distro-ver-9.6"
      ]
    }

    rocky_8_9 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-rocky",
        "distro-ver-8.9"
      ]
    }
    rocky_8_10 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-rocky",
        "distro-ver-8.10"
      ]
    }
    rocky_9_5 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-rocky",
        "distro-ver-9.5"
      ]
    }
    rocky_9_6 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-rocky",
        "distro-ver-9.6"
      ]
    }

    debian_11_11_0 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-debian",
        "distro-ver-11.11.0"
      ]
    }
    debian_12_7_0 = {
      tags = [
        "os-linux",
        "cloud-init",
        "distro-debian",
        "distro-ver-12.7.0"
      ]
    }

    ## tk1b only
    #rhel_8_10 = {
    #  tags = [
    #    "os-linux",
    #    "cloud-init",
    #    "distro-rhel",
    #    "distro-ver-8.10"
    #  ]
    #}
    #rhel_9_6 = {
    #  tags = [
    #    "os-linux",
    #    "cloud-init",
    #    "distro-rhel",
    #    "distro-ver-9.6"
    #  ]
    #}
  }
}
