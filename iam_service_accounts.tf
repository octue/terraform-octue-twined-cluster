resource "google_service_account" "kubernetes" {
  account_id   = "${var.environment}-octue-twined-kubernetes"
  display_name = "${var.environment}-octue-twined-kubernetes"
  project      = var.google_cloud_project_id
  description  = "Allow the Octue Twined Kubernetes cluster to access resources in the ${var.environment} environment."
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}
