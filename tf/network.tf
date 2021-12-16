resource "google_compute_network" "nixos_network" {
  name = "nixos-network"
}

resource "google_compute_firewall" "allow_internal" {
  name = "allow-internal"
  network = google_compute_network.nixos_network.self_link

  source_service_accounts = [
    google_service_account.default.email
  ]

  target_service_accounts = [
    google_service_account.default.email
  ]

  # TODO: probably insecure, fix me
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "allow_web" {
  name = "allow-web"
  network = google_compute_network.nixos_network.self_link
  source_ranges = [ "0.0.0.0/0" ]

  allow {
    protocol = "tcp"
    ports = [ "80", "443" ]
  }
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

resource "google_compute_firewall" "allow_nomad" {
  name = "allow-nomad-web-ui"
  network = google_compute_network.nixos_network.self_link
  source_ranges = [ "0.0.0.0/0" ]

  allow {
    protocol = "tcp"
    ports = [ "4646" ]
  }
}

resource "google_compute_firewall" "allow_consul" {
  name = "allow-consul-web-ui"
  network = google_compute_network.nixos_network.self_link
  source_ranges = [ "0.0.0.0/0" ]

  allow {
    protocol = "tcp"
    ports = [ "8500" ]
  }
}