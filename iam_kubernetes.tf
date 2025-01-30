locals {
  kubernetes_node_roles = tolist(
    [
      "roles/container.defaultNodeServiceAccount",
      "roles/artifactregistry.reader",
      "roles/iam.serviceAccountUser",
      "roles/pubsub.admin",
      "roles/errorreporting.writer"
    ]
  )
}


resource "google_service_account" "kubernetes_node_service_account" {
  account_id   = "${var.environment}-octue-twined-kubernetes"
  display_name = "${var.environment}-octue-twined-kubernetes"
  project      = var.google_cloud_project_id
  description  = "Allow the Octue Twined Kubernetes cluster to access resources in the ${var.environment} environment."
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "kubernetes_node_roles" {
  count = length(local.kubernetes_node_roles)
  project = var.google_cloud_project_id
  role    = local.kubernetes_node_roles[count.index]
  member  = "serviceAccount:${google_service_account.kubernetes_node_service_account.email}"
}
