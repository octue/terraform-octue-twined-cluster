locals {
  kubernetes_node_roles = toset(
    [
      "roles/container.defaultNodeServiceAccount",
      "roles/artifactregistry.reader",
      "roles/iam.serviceAccountUser",
      "roles/pubsub.admin",
      "roles/errorreporting.writer",
      "roles/storage.admin",
    ]
  )
}


resource "google_service_account" "kubernetes" {
  account_id   = "${var.environment}-octue-twined-kubernetes"
  display_name = "${var.environment}-octue-twined-kubernetes"
  project      = var.google_cloud_project_id
  description  = "Allow the Octue Twined Kubernetes cluster to access resources in the ${var.environment} environment."
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "kubernetes__roles" {
  for_each   = local.kubernetes_node_roles
  project    = var.google_cloud_project_id
  role       = each.value
  member     = "serviceAccount:${google_service_account.kubernetes.email}"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "kubernetes_service_account__roles" {
  for_each = local.kubernetes_node_roles
  project  = var.google_cloud_project_id
  role     = each.value
  member   = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.google_cloud_project_id}.svc.id.goog/subject/ns/default/sa/${kubernetes_service_account.default.metadata[0].name}"
}


resource "google_storage_bucket_iam_member" "kubernetes__storage__admin" {
  bucket = "${var.google_cloud_project_id}-octue-twined"
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.kubernetes.email}"
}
