locals {
  kubernetes_node_roles = toset(
    [
      "roles/container.defaultNodeServiceAccount",
      "roles/artifactregistry.reader",
      "roles/iam.serviceAccountUser",
      "roles/pubsub.admin",
      "roles/errorreporting.writer"
    ]
  )
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


resource "google_service_account_iam_member" "kubernetes_service_account__iam_impersonation" {
  service_account_id = google_service_account.kubernetes.name
  role = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.google_cloud_project_id}.svc.id.goog[default/${kubernetes_service_account.default.metadata[0].name}]"
}
