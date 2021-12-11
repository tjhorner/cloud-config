data "google_compute_image" "nixos" {
  // project = "nixos-cloud"
  name = "packer-1639179865"
}

resource "google_service_account" "default" {
  account_id = "nixos-service-account"
  display_name = "NixOS Default Service Account"
}

resource "google_compute_network" "nixos_network" {
  name = "nixos-network"
}

resource "google_compute_firewall" "allow_ssh" {
  name = "allow-ssh"
  network = google_compute_network.nixos_network.self_link
  source_ranges = [ "0.0.0.0/0" ]

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }
}

// resource "google_compute_firewall" "allow_nomad" {
//   name = "allow-nomad-web-ui"
//   network = google_compute_network.nixos_network.self_link
//   source_ranges = [ "0.0.0.0/0" ]

//   allow {
//     protocol = "tcp"
//     ports = [ "4646" ]
//   }
// }

resource "google_compute_instance" "nixos_vm" {
  name = "nixos-test"
  machine_type = var.gcp_machine_type
  allow_stopping_for_update = true

  metadata = {
    enable-oslogin = "TRUE"
  }

  network_interface {
    network = google_compute_network.nixos_network.self_link

    access_config {
      network_tier = "STANDARD"
    }
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.nixos.self_link
      size = 32
    }
  }

  service_account {
    email = google_service_account.default.email
    scopes = [ "cloud-platform" ]
  }
}