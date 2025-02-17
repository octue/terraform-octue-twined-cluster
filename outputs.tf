# - SRUID for each service revision (or just SUID?)

output "event_store" {
  description = "The full ID of the BigQuery table acting as the Octue Twined services event store."
  value       = "${google_bigquery_dataset.service_event_dataset.dataset_id}.${google_bigquery_table.service_event_table.table_id}"
}


output "service_registry" {
  description = "The URL of the service registry."
  value       = google_cloudfunctions2_function.service_registry.url
}


output "storage_bucket" {
  description = "The `gs://` URL of the storage bucket used to store service inputs, outputs, and diagnostics."
  value = google_storage_bucket.default.url
}


output "services_topic" {
  description = "The Pub/Sub topic that all Octue Twined service events are published to."
  value       = google_pubsub_topic.services_topic.name
}


output "kubernetes_cluster" {
  value = google_container_cluster.primary
}
