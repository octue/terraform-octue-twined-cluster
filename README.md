# terraform-octue-twined-cluster
A terraform module for deploying a Kubernetes cluster for an Octue Twined service network to GCP.

> [!IMPORTANT]
> This Terraform module must be deployed **after** the 
> [terraform-octue-twined-core](https://github.com/octue/terraform-octue-twined-core) module in the same GCP project. 
> Both must be deployed to have a cloud-based Octue Twined services network. See 
> [a live example here](https://github.com/octue/twined-infrastructure).

> [!TIP]
> Deploy this module in a separate Terraform configuration (directory/workspace) to the 
> [terraform-octue-twined-core](https://github.com/octue/terraform-octue-twined-core) 
> module. This allows the option to spin down the Kubernetes cluster while keeping the core resources that contain all 
> data produced by your Twined services available. Spinning the cluster down entirely can save on running costs in 
> periods of extended non-use while keeping all data available.


# Infrastructure
This module is designed to manage multiple environments (e.g. testing, staging, production) in the same GCP project
simultaneously. Environments provide isolated Twined service networks that can't easily interact with service networks 
in other environments. 

These resources are automatically deployed for each given environment:
- An autopilot GKE Kubernetes cluster for running Twined service containers on. [Kueue](https://kueue.sigs.k8s.io/) is 
  installed on the cluster to provide a queueing system where questions sent to Twined services are treated as jobs
- A Kueue cluster queue, local queue, and default resource flavour to implement the job queueing system on the cluster
- A Pub/Sub topic for all Twined service events to be published to
- An event handler cloud function that stores all events in the event store and dispatches question events to the 
  Kubernetes cluster as Kueue jobs
- A service registry cloud function providing an HTTP endpoint for checking if an image exists in the artifact registry 
  repository for any requested service revisions
- An IAM service account and roles mapped to a Kubernetes service account for the cluster to use to access the resources
  deployed by the [terraform-octue-twined-core](https://github.com/octue/terraform-octue-twined-core) Terraform module
- IAM roles for relevant google service agents


# Installation and usage
Add the below blocks to your Terraform configuration and run:
```shell
terraform init
terraform plan
```

If you're happy with the plan, run:
```shell
terraform apply
```
and approve the run. This will create resources whose names/IDs are prefixed with `<environment>-` where `<environment>`
is `main` by default.

## Environments
The suggested way of managing environments is via [Terraform workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces).
You can get started right away with the `main` environment by removing the `environment` input to the module. 

To create and used other environments, see the example configuration below. It contains a `locals` block that 
automatically generates the environment name from the name of the current Terraform workspace by taking the text after 
the final hyphen. This supports uniquely named environments in Terraform Cloud (which must be unique within the 
organisation) while keeping the environment prefix short but unique within your GCP project. For this to work well, 
ensure your Terraform workspace names are slugified.

For example, if your Terraform workspace was called `my-project-testing`, the environment would be called `testing` and
your resources would be named like this:
- Pub/Sub topic: `testing.octue.twined.services`
- Event handler: `testing-octue-twined-service-event-handler`
- Service registry: `testing-octue-twined-service-registry`
- Kubernetes cluster: `testing-octue-twined-cluster`


## Example configuration

```terraform
# main.tf

terraform {
  required_version = ">= 1.8.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6.12"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~>2.35"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.19"
    }
  }
  
}


provider "google" {
  project     = var.google_cloud_project_id
  region      = var.google_cloud_region
}


data "google_client_config" "default" {}


provider "kubernetes" {
  host                   = "https://${module.octue_twined_cluster.kubernetes_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.octue_twined_cluster.kubernetes_cluster.master_auth[0].cluster_ca_certificate)
}


provider "kubectl" {
  load_config_file       = false
  host                   = "https://${module.octue_twined_cluster.kubernetes_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.octue_twined_cluster.kubernetes_cluster.master_auth[0].cluster_ca_certificate)
}


# Set the environment name to the last part of the workspace name when split on hyphens.
locals {
  workspace_split = split("-", terraform.workspace)
  environment = element(local.workspace_split, length(local.workspace_split) - 1)
}


module "octue_twined_cluster" {
  source = "git::github.com/octue/terraform-octue-twined-cluster.git?ref=0.1.1"
  google_cloud_project_id = var.google_cloud_project_id
  google_cloud_region = var.google_cloud_region
  environment = local.environment
  cluster_queue = var.cluster_queue
}
```

```terraform
# variables.tf

variable "google_cloud_project_id" {
  type = string
  default = "<google-cloud-project-id>"
}


variable "google_cloud_region" {
  type = string
  default = "<google-cloud-region>"
}


variable "cluster_queue" {
  type = object(
    {
      name                 = string
      max_cpus              = number
      max_memory            = string
      max_ephemeral_storage = string
    }
  )
  default = {
    name                  = "cluster-queue"
    max_cpus              = 100
    max_memory            = "256Gi"
    max_ephemeral_storage = "10Gi"
  }
}
```

## Dependencies
- Terraform: `>= 1.8.0, <2`
- Providers:
  - `hashicorp/google`: `~>6.12`
  - `hashicorp/kubernetes`: `~>2.35`
  - `gavinbunney/kubectl`: `~>1.19`
- Google cloud APIs:
  - The Cloud Resource Manager API must be [enabled manually](https://console.developers.google.com/apis/api/cloudresourcemanager.googleapis.com) 
    before using the module
  - All other required google cloud APIs are enabled automatically by the module 

## Authentication

> [!TIP]
> You can use the same service account as created for the [terraform-octue-twined-core](https://github.com/octue/terraform-octue-twined-core?tab=readme-ov-file#authentication)
> module to skip steps 1 and 2.

The module needs to authenticate with google cloud before it can be used:

1. Create a service account for Terraform and assign it the `editor` and `owner` basic IAM permissions
2. Download a JSON key file for the service account
3. If using Terraform Cloud, follow [these instructions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#using-terraform-cloud).
   before deleting the key file from your computer 
4. If not using Terraform Cloud, follow [these instructions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication-configuration)
   or use another [authentication method](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication)

## Destruction
> [!WARNING]
> If the `deletion_protection` input is set to `true`, it must first be set to `false` and `terraform apply` run before 
> running `terraform destroy` or any other operation that would result in the destruction or replacement of the cluster.
> Not doing this can lead to a state needing targeted Terraform commands and/or manual configuration changes to recover 
> from.

Disable `deletion_protection` and run:
```shell
terraform destroy
```


# Input reference

| Name                                 | Type          | Required | Default                                                                                |
|--------------------------------------|---------------|----------|----------------------------------------------------------------------------------------| 
| `google_cloud_project_id`            | `string`      | Yes      | N/A                                                                                    |  
| `google_cloud_region`                | `string`      | Yes      | N/A                                                                                    |
| `maintainer_service_account_names`   | `set(string)` | No       | `["default"]`                                                                          |
| `environment`                        | `string`      | No       | `"main"`                                                                               |
| `maximum_event_handler_instances`    | `number`      | No       | `100`                                                                                  |
| `maximum_service_registry_instances` | `number`      | No       | `10`                                                                                   |
| `deletion_protection`                | `bool`        | No       | `true`                                                                                 |
| `kueue_version`                      | `string`      | No       | `"v0.10.1"`                                                                            |
| `question_default_resources`         | `object`      | No       | `{cpus=1, memory="512Mi", ephemeral_storage="1Gi"}`                                    |
| `cluster_queue`                      | `object`      | No       | `{name="cluster-queue", max_cpus=10, max_memory="10Gi", max_ephemeral_storage="10Gi"}` |
| `local_queue`                        | `object`      | No       | `{name="local-queue"}`                                                                 |


See [`variables.tf`](/variables.tf) for descriptions.


# Output reference

| Name                   | Type     |
|------------------------|----------|
| `service_registry_url` | `string` | 
| `services_topic_name`  | `string` | 
| `kubernetes_cluster`   | `string` | 

See [`outputs.tf`](/outputs.tf) for descriptions.
