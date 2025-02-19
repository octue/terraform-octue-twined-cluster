resource "google_service_account" "developers" {
  for_each     = var.service_account_names
  account_id   = "${var.environment}-${each.key}"
  display_name = "${var.environment}-${each.key}"
  project      = var.google_cloud_project_id
  description  = "Allow ${each.key} to access most resources related to Octue Twined services in the ${var.environment} environment."
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_service_account" "kubernetes" {
  account_id   = "${var.environment}-octue-twined-kubernetes"
  display_name = "${var.environment}-octue-twined-kubernetes"
  project      = var.google_cloud_project_id
  description  = "Allow the Octue Twined Kubernetes cluster to access resources in the ${var.environment} environment."
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}
