# Artifact Registry is used to store docker images of the Twined services.
resource "google_project_service" "artifact_registry" {
  project = var.google_cloud_project_id
  service = "artifactregistry.googleapis.com"
}


# BigQuery provides the event store for Twined service events (questions, results, log messages etc.).
resource "google_project_service" "bigquery" {
  project = var.google_cloud_project_id
  service = "bigquery.googleapis.com"
}


# Cloud Functions runs the event handler that directs Twined service events to the event store.
resource "google_project_service" "cloud_functions" {
  project = var.google_cloud_project_id
  service = "cloudfunctions.googleapis.com"
}


# Cloud Run runs the Twined services as docker containers.
resource "google_project_service" "cloud_run" {
  project = var.google_cloud_project_id
  service = "run.googleapis.com"
}


# IAM provides fine-grained authentication and authorisation to use and access the Twined services and input/output data.
resource "google_project_service" "iam" {
  project = var.google_cloud_project_id
  service = "iam.googleapis.com"
}


# Pub/Sub is the transport mechanism for Twined service events.
resource "google_project_service" "pub_sub" {
  project = var.google_cloud_project_id
  service = "pubsub.googleapis.com"
}
