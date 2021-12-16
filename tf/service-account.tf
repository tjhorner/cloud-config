resource "google_service_account" "default" {
  account_id = "nixos-service-account"
  display_name = "NixOS Default Service Account"
}

resource "google_project_iam_member" "allow_compute" {
  role = "roles/compute.viewer"
  member = "serviceAccount:${google_service_account.default.email}"
  project = var.gcp_project_id
}

resource "google_project_iam_member" "allow_filestore" {
  role = "roles/file.editor"
  member = "serviceAccount:${google_service_account.default.email}"
  project = var.gcp_project_id
}