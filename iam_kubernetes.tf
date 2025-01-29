locals {
  cluster_iam_roles = tolist(
    [
      "roles/container.defaultNodeServiceAccount",
      "roles/artifactregistry.reader",
      "roles/iam.serviceAccountUser",
      "roles/pubsub.editor",
      "roles/errorreporting.writer"
    ]
  )
  # eventarc_roles = tolist(
  #   [
  #     "roles/compute.viewer",
  #     "roles/container.developer",
  #     "roles/iam.serviceAccountAdmin",
  #     "roles/eventarc.serviceAgent"
  #   ]
  # )
  # gke_receiver_roles = tolist(
  #   [
  #     "roles/eventarc.eventReceiver",
  #     "roles/pubsub.subscriber"
  #   ]
  # )
}


resource "google_project_iam_member" "default_node_service_account" {
  count = length(local.cluster_iam_roles)
  project = var.google_cloud_project_id
  role    = local.cluster_iam_roles[count.index]
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}


resource "kubernetes_service_account" "kubernetes_google_wif_service_account" {
  metadata {
    name = "google_workload_identity_federation"
  }
}


resource "google_project_iam_member" "kubernetes_wif_roles" {
  count = length(local.cluster_iam_roles)
  project = var.google_cloud_project_id
  role    = local.cluster_iam_roles[count.index]
  member  = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.google_cloud_project_id}.svc.id.goog/subject/ns/default/sa/${kubernetes_service_account.kubernetes_google_wif_service_account.metadata.name}"
}


# # Creating these IAM bindings is the equivalent of running `gcloud eventarc gke-destinations init` and
# # `gcloud beta services identity create --service eventarc.googleapis.com`.
# resource "google_project_iam_binding" "eventarc_service_agent_gke_destinations_bindings" {
#   count = length(local.eventarc_roles)
#   project = var.google_cloud_project_id
#   role = local.eventarc_roles[count.index]
#   members = ["serviceAccount:service-${data.google_project.project.number}@gcp-sa-eventarc.iam.gserviceaccount.com"]
# }
#
#
# # Create a service account to be used by GKE trigger.
# resource "google_service_account" "eventarc_gke_trigger_service_account" {
#   account_id   = "eventarc-gke-trigger-sa"
#   display_name = "Evenarc GKE Trigger Service Account"
# }
#
# # Grant permission to receive Eventarc events and subscribe to Pub/Sub topics.
# resource "google_project_iam_binding" "event_receiver" {
#   count = length(local.gke_receiver_roles)
#   project = var.google_cloud_project_id
#   role    = local.gke_receiver_roles[count.index]
#   members  = ["serviceAccount:${google_service_account.eventarc_gke_trigger_service_account.email}"]
# }
