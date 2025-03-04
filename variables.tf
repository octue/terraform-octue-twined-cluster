variable "google_cloud_project_id" {
  type = string
}


variable "google_cloud_region" {
  type = string
}


variable "maintainer_service_account_names" {
  type = set(string)
}


variable "storage_bucket_name" {
  type = string
}


variable "environment" {
  type    = string
  default = "main"
}


variable "maximum_event_handler_instances" {
  type    = number
  default = 100
}


variable "maximum_service_registry_instances" {
  type    = number
  default = 10
}


variable "artifact_registry_repository_name" {
  type    = string
  default = "octue-twined-services"
}


variable "bigquery_events_table_id" {
  type    = string
  default = "octue_twined.service-events"
}


variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Apply deletion protection to the Kubernetes cluster"
}


variable "kueue_version" {
  type    = string
  default = "v0.10.1"
}


variable "question_default_resources" {
  type = object(
    {
      cpus              = number
      memory            = string
      ephemeral_storage = string
    }
  )
  default = {
    cpus              = 1
    memory            = "512Mi"
    ephemeral_storage = "1Gi"
  }
  description = <<EOT
    cpus: the number of CPUs to allocate each question by default
    memory: the amount of memory to allocate each question by default e.g. "500Mi" or "4Gi"
    ephemeral_storage: the amount of ephemeral storage to allocate each question by default e.g. "500Mi" or "4Gi"
  EOT
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
