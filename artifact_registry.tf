resource "google_artifact_registry_repository" "service_docker_images" {
  repository_id = "${var.octue_service_namespace}_octue_services"
  description   = "Docker image repository"
  format        = "DOCKER"
  location      = var.google_cloud_region
}
