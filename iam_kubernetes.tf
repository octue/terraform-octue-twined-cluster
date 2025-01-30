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


resource "google_project_iam_member" "default_node_service_account" {
  count = length(local.cluster_iam_roles)
  project = var.google_cloud_project_id
  role    = local.cluster_iam_roles[count.index]
  member  = "serviceAccount:${google_service_account.kubernetes_node_service_account.email}"
}
