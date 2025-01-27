resource "google_cloudfunctions2_function" "event_handler" {
  name        = "${var.environment}-octue-twined-service-event-handler"
  description = "A function for handling events from Octue Twined services."
  location    = var.google_cloud_region

  build_config {
    runtime     = "python312"
    entry_point = "handle_event"
    source {
      storage_source {
        bucket = "twined-gcp"
        object = "event_handler/0.7.0-rc.1.zip"
      }
    }
  }

  service_config {
    max_instance_count = var.maximum_event_handler_instances
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
      BIGQUERY_EVENTS_TABLE = "${google_bigquery_dataset.service_event_dataset.dataset_id}.${google_bigquery_table.service_event_table.table_id}"
      KUEUE_LOCAL_QUEUE = var.local_queue
      ARTIFACT_REGISTRY_REPOSITORY_URL = "${var.google_cloud_region}-docker.pkg.dev/${var.google_cloud_project_id}/${google_artifact_registry_repository.service_docker_images.name}"
    }
  }

  event_trigger {
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.services_topic.id
    trigger_region = var.google_cloud_region
    retry_policy   = "RETRY_POLICY_RETRY"
  }
}
