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

variable "gcp_base_image" {
  type = string
}

variable "consul_instances" {
  type = number
  default = 1
}

variable "nomad_instances" {
  type = number
  default = 2
}