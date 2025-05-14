locals {
  apis = toset(
    [
      "cloudbuild.googleapis.com",
      "cloudfunctions.googleapis.com", # Cloud Functions runs the event handler that directs Twined service events to the event store.
      "container.googleapis.com",      # Google Kubernetes Engine (GKE) runs the Twined services
      "eventarc.googleapis.com",       # Eventarc is used to communicate with the Cloud Function via Pub/Sub.
      "pubsub.googleapis.com",         # Pub/Sub is the transport mechanism for Twined service events.
      "run.googleapis.com"             # Needed for cloud functions.
    ]
  )
}


resource "google_project_service" "google_apis" {
  for_each                   = local.apis
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
  project                    = var.google_cloud_project_id
}


resource "time_sleep" "wait_for_google_apis_to_enable" {
  depends_on      = [google_project_service.google_apis]
  create_duration = "1m"
}
