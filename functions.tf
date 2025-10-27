locals {
  artifact_registry_repository_name = "octue-twined-services"
}

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
        object = "event_handler/0.9.0.zip"
      }
    }
  }

  service_config {
    max_instance_count = var.maximum_event_handler_instances
    available_memory   = "256M"
    timeout_seconds    = 60
    ingress_settings   = "ALLOW_INTERNAL_ONLY"
    environment_variables = {
      ARTIFACT_REGISTRY_REPOSITORY_URL   = "${var.google_cloud_region}-docker.pkg.dev/${var.google_cloud_project_id}/${local.artifact_registry_repository_name}"
      BIGQUERY_EVENTS_TABLE              = "octue_twined.service-events"
      KUBERNETES_CLUSTER_ID              = google_container_cluster.primary.id
      KUBERNETES_SERVICE_ACCOUNT_NAME    = kubernetes_service_account.default.metadata[0].name
      KUEUE_LOCAL_QUEUE                  = var.local_queue.name
      TWINED_SERVICES_TOPIC_NAME          = google_pubsub_topic.services_topic.name
      QUESTION_DEFAULT_CPUS              = var.question_default_resources.cpus
      QUESTION_DEFAULT_MEMORY            = var.question_default_resources.memory
      QUESTION_DEFAULT_EPHEMERAL_STORAGE = var.question_default_resources.ephemeral_storage
    }
  }

  event_trigger {
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.services_topic.id
    trigger_region = var.google_cloud_region
    retry_policy   = "RETRY_POLICY_RETRY"
  }

  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_cloudfunctions2_function" "service_registry" {
  name        = "${var.environment}-octue-twined-service-registry"
  description = "A lightweight service registry for Octue Twined services running on Kueue."
  location    = var.google_cloud_region

  build_config {
    runtime     = "python312"
    entry_point = "handle_request"
    source {
      storage_source {
        bucket = "twined-gcp"
        object = "service_registry/0.8.2.zip"
      }
    }
  }

  service_config {
    max_instance_count = var.maximum_service_registry_instances
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
      ARTIFACT_REGISTRY_REPOSITORY_ID = "projects/${var.google_cloud_project_id}/locations/${var.google_cloud_region}/repositories/${local.artifact_registry_repository_name}"
    }
  }
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}
