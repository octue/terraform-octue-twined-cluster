resource "google_service_account" "github_actions_service_account" {
  account_id   = "${var.environment}-github-actions"
  description  = "Allow GitHub Actions to test and deploy Octue Twined services in the ${var.environment} environment."
  display_name = "${var.environment}-github-actions"
  project      = var.google_cloud_project_id
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_service_account" "admin_accounts" {
  for_each     = var.service_account_names
  account_id   = "${var.environment}-${each.key}"
  display_name = "${var.environment}-${each.key}"
  project      = var.google_cloud_project_id
  description  = "Allow ${each.key} to access most resources related to Octue Twined services in the ${var.environment} environment."
  depends_on   = [time_sleep.wait_for_google_apis_to_enable]
}
