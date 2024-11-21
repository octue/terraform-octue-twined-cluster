variable "google_cloud_project_id" {
  type    = string
}

variable "google_cloud_project_number" {
  type = string
}

variable "google_cloud_region" {
  type = string
}

variable "github_organisation" {
  type    = string
}

variable "octue_service_namespace" {
  type    = string
}

variable "octue_service_name" {
  type    = string
}

variable "google_cloud_credentials_file" {
  type    = string
  default = "gcp-credentials.json"
}
