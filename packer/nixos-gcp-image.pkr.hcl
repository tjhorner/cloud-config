packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "gcp_project_id" {
  type = string
}

source "googlecompute" "nixos_base" {
  source_image_project_id = [ "nixos-cloud" ]
  source_image = "nixos-image-20-09-3531-3858fbc08e6-x86-64-linux"

  project_id = var.gcp_project_id
  use_os_login = true
  ssh_username = "root"
  zone = "us-central1-a"
}

build {
  image_name = "nixos-21-11"
  sources = [ "sources.googlecompute.nixos_base" ]

  provisioner "shell" {
    script = "./bootstrap.sh"
    valid_exit_codes = [ 0, 1 ]
  }
}