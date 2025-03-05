output "service_registry" {
  value       = google_cloudfunctions2_function.service_registry.url
  description = "The URL of the service registry."
}


output "services_topic" {
  value       = google_pubsub_topic.services_topic.name
  description = "The Pub/Sub topic that all Twined service events are published to."
}


output "kubernetes_cluster" {
  value       = google_container_cluster.primary
  description = "The Kubernetes cluster that Twined service containers are run on."
}
