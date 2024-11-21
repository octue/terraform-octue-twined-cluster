resource "google_artifact_registry_repository" "service_docker_images" {
  repository_id = "${var.twined_service_namespace}_octue_twined_services"
  description   = "Docker image repository for Octue Twined services"
  format        = "DOCKER"
  location      = var.google_cloud_region
}
