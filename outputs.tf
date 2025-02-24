output "service_registry" {
  description = "The URL of the service registry."
  value       = google_cloudfunctions2_function.service_registry.url
}


output "services_topic" {
  description = "The Pub/Sub topic that all Octue Twined service events are published to."
  value       = google_pubsub_topic.services_topic.name
}


output "kubernetes_cluster" {
  value = google_container_cluster.primary
}
