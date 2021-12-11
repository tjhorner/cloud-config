variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
  default = "us-central1"
}

variable "gcp_zone" {
  type = string
  default = "us-central1-a"
}

variable "gcp_machine_type" {
  type = string
  default = "e2-micro"
}
