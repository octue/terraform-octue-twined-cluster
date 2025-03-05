variable "google_cloud_project_id" {
  type        = string
  description = "The ID of the google cloud project to deploy resources in."
}


variable "google_cloud_region" {
  type        = string
  description = "The google cloud region to deploy resources in."
}


variable "maintainer_service_account_names" {
  type        = set(string)
  default     = ["default"]
  description = "The names of the maintainer IAM service accounts (without the 'maintainer-' prefix)."
}


variable "environment" {
  type        = string
  default     = "main"
  description = "The name of the environment to deploy the resources in (must be one word with no hyphens or underscores in). This can be derived from a Terraform workspace name and used to facilitate e.g. testing and staging environments alongside the production environment ('main')."
}


variable "maximum_event_handler_instances" {
  type        = number
  default     = 100
  description = "The maximum number of instances to allow to be spun up simultaneously for the event handler. Each instance can handle one event at a time."
}


variable "maximum_service_registry_instances" {
  type        = number
  default     = 10
  description = "The maximum number of instances to allow to be spun up simultaneously for the service registry. Each instance can handle one request at a time."
}


variable "deletion_protection" {
  type        = bool
  default     = true
  description = "If `true`, disallow deletion of the Kubernetes cluster. `terraform apply` must be run after setting this to `false` before `terraform destroy` will be able to destroy the cluster."
}


variable "kueue_version" {
  type        = string
  default     = "v0.10.1"
  description = "The version of Kueue to install on the Kubernetes cluster. Any release from https://github.com/kubernetes-sigs/kueue/releases with a `manifests.yaml` artifact can be used."
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
    max_cpus: the maximum number of CPUs the cluster queue can allocate to all questions running simultaneously on the cluster
    max_memory: the maximum amount of memory the cluster queue can allocate to all questions running simultaneously on the cluster e.g. "500Mi" or "4Gi"
    max_ephemeral_storage: the maximum amount of ephemeral storage the cluster queue can allocate to all questions running simultaneously on the cluster e.g. "500Mi" or "4Gi"
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
