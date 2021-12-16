terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.3.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region = var.gcp_region
  zone = var.gcp_zone
}

provider "nomad" {
  address = "http://${google_compute_instance.nomad_server[0].network_interface[0].access_config[0].nat_ip}:4646"
  region = "global"
}