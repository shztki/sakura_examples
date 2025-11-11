provider "sakuracloud" {
  zone = var.zone
}

module "label" {
  source      = "cloudposse/label/null"
  namespace   = var.label["namespace"]
  stage       = var.label["stage"]
  name        = var.label["name"]
  attributes  = [var.label["namespace"], var.label["stage"], var.label["name"]]
  delimiter   = "-"
  label_order = ["namespace", "stage", "name"]
}

terraform {
  required_version = "~> 1.13.1"
  #cloud {}
  #backend "s3" {
  #  bucket                      = "bucket-name"
  #  key                         = "01_vpn_cloud-init/terraform.tfstate"
  #  region                      = "jp-north-1"
  #  endpoint                    = "https://s3.isk01.sakurastorage.jp"
  #  skip_requesting_account_id  = true
  #  skip_credentials_validation = true
  #  skip_region_validation      = true
  #  skip_metadata_api_check     = true
  #  skip_s3_checksum            = true
  #}

  required_providers {
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "~> 2.31.1"
    }
  }
}
