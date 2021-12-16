data "google_compute_image" "nixos" {
  name = var.gcp_base_image
}

resource "google_compute_instance" "consul_server" {
  count = var.consul_instances

  name = "consul-server-${count.index + 1}"
  machine_type = var.gcp_machine_type
  allow_stopping_for_update = true
  metadata_startup_script = templatefile("./scripts/nixconfig.sh", { nixos_config = "consul-server" })
  tags = [ "consul-server" ]

  metadata = {
    enable-oslogin = "TRUE"
    bootstrap-expect = "${var.consul_instances}"
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

resource "google_compute_instance" "nomad_server" {
  count = var.nomad_instances

  name = "nomad-server-${count.index + 1}"
  machine_type = var.gcp_machine_type
  allow_stopping_for_update = true
  metadata_startup_script = templatefile("./scripts/nixconfig.sh", { nixos_config = "nomad-server" })
  tags = [ "nomad-server" ]

  metadata = {
    enable-oslogin = "TRUE"
    bootstrap-expect = "${var.nomad_instances}"
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