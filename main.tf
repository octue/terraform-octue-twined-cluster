terraform {
  required_version = ">= 1.8.0, <2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>6.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.35"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.19"
    }
  }
}


data "google_project" "project" {}
