locals {
  cluster_iam_roles = tolist(
    [
      "roles/container.defaultNodeServiceAccount",
      "roles/artifactregistry.reader",
      "roles/iam.serviceAccountUser",
      "roles/pubsub.admin",
      "roles/errorreporting.writer"
    ]
  )
}


resource "google_project_iam_member" "default_node_service_account" {
  count = length(local.cluster_iam_roles)
  project = var.google_cloud_project_id
  role    = local.cluster_iam_roles[count.index]
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}


data "google_iam_policy" "gke_workload_identity_pool_policy" {
  binding {
    role = "roles/iam.workloadIdentityUser"
    members = [
      "${data.google_project.project.number}-compute@developer.gserviceaccount.com:${var.google_cloud_project_id}.svc.id.goog[${kubernetes_service_account.kubernetes_google_wif_service_account.metadata[0].name}]"
    ]
  }
}


# Allow a machine under Workload Identity Federation to act as the given service account.
resource "google_service_account_iam_policy" "gke_workload_identity_service_account_policy" {
  policy_data        = data.google_iam_policy.gke_workload_identity_pool_policy.policy_data
  service_account_id = "projects/${var.google_cloud_project_id}/serviceAccounts/${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}


resource "kubernetes_service_account" "kubernetes_google_wif_service_account" {
  metadata {
    name = "google-workload-identity-federation"
    annotations = {
      "iam.gke.io/gcp-service-account" = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
    }
  }
}


resource "google_project_iam_member" "kubernetes_wif_roles" {
  count = length(local.cluster_iam_roles)
  project = var.google_cloud_project_id
  role    = local.cluster_iam_roles[count.index]
  member  = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.google_cloud_project_id}.svc.id.goog/subject/ns/default/sa/${kubernetes_service_account.kubernetes_google_wif_service_account.metadata[0].name}"
}
