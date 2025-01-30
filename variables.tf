variable "google_cloud_project_id" {
  type = string
}

variable "google_cloud_region" {
  type = string
}

variable "github_organisation" {
  type = string
}

variable "environment" {
  type = string
  default = "main"
}

variable "service_account_names" {
  type = set(string)
}

variable "maximum_event_handler_instances" {
  type    = number
  default = 100
}

variable "deletion_protection" {
  type    = bool
  default = true
  description = "Apply deletion protection to the event store and Kubernetes cluster."
}

variable "use_gha_workload_identity_federation" {
  type = bool
  default = false
  description = "Create a workload identity federation pool and provider for GitHub Actions."
}

variable "kueue_version" {
  type = string
  default = "v0.10.1"
}

variable "cpus" {
  type = number
  default = 2
}

variable "memory" {
  type = string
  default = "2Gi"
}

variable "local_queue" {
  type = string
  default = "local-queue"
}

variable "cluster_queue" {
  type = string
  default = "cluster-queue"
}
