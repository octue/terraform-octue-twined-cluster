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
