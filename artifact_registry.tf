resource "google_artifact_registry_repository" "service_docker_images" {
  repository_id = "${var.twined_service_namespace}_twined_services"
  description   = "Docker image repository"
  format        = "DOCKER"
  location      = var.google_cloud_region
}
