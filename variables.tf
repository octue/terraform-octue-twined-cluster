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
  type    = string
  default = "main"
}

variable "service_account_names" {
  type = set(string)
}

variable "maximum_event_handler_instances" {
  type    = number
  default = 100
}

variable "maximum_service_registry_instances" {
  type    = number
  default = 10
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Apply deletion protection to the event store, Kubernetes cluster, and storage buckets."
}

variable "use_gha_workload_identity_federation" {
  type        = bool
  default     = false
  description = "Create a workload identity federation pool and provider for GitHub Actions."
}

variable "kueue_version" {
  type    = string
  default = "v0.10.1"
}


variable "memory" {
  type        = string
  default     = "2Gi"
  description = "The maximum amount of memory to provide to the cluster queue."
}


variable "cluster_queue" {
  type = object(
    {
      name                  = string
      max_cpus              = number
      max_memory            = string
      max_ephemeral_storage = string
    }
  )
  default = {
    name                  = "cluster-queue"
    max_cpus              = 10
    max_memory            = "10Gi"
    max_ephemeral_storage = "10Gi"
  }
  description = <<EOT
    name: the name to give the cluster queue
    max_cpus: the maximum number of CPUs the cluster queue can allocate to all questions
    max_memory: the maximum amount of memory the cluster queue can allocate to all questions e.g. "500Mi" or "4Gi"
    max_ephemeral_storage: the maximum amount of ephemeral storage the cluster queue can allocate to all questions e.g. "500Mi" or "4Gi"
  EOT
}


variable "local_queue" {
  type = object(
    {
      name = string
    }
  )
  default = {
    name = "local-queue"
  }
  description = <<EOT
    name: the name to give the local queue
  EOT
}
