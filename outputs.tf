# - SRUID for each service revision (or just SUID?)

output "event_store" {
  description = "The full ID of the BigQuery table acting as the Octue Twined services event store."
  value       = google_bigquery_table.service_event_table.table_id
}


output "services_topic" {
  description = "The Pub/Sub topic that all Octue Twined service events are published to."
  value = google_pubsub_topic.services_topic.name
}


output "kubernetes_cluster" {
  value = google_container_cluster.primary
}
