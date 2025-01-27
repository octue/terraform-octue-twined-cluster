resource "google_iam_workload_identity_pool" "github_actions_pool" {
  count = var.use_gha_workload_identity_federation ? 1 : 0
  workload_identity_pool_id = "${var.environment}-github-actions-pool"
  display_name              = "${var.environment}-github-actions-pool"
  project                   = var.google_cloud_project_id
  depends_on                = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_iam_workload_identity_pool_provider" "github_actions_provider" {
  count = var.use_gha_workload_identity_federation ? 1 : 0
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pool[0].id
  workload_identity_pool_provider_id = "${var.environment}-github-actions-provider"
  display_name                       = "${var.environment}-github-actions-provider"
  project                            = data.google_project.project.number
  depends_on                         = [time_sleep.wait_for_google_apis_to_enable]

  attribute_condition = "attribute.repository_owner==\"${var.github_organisation}\""

  attribute_mapping = {
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "google.subject"             = "assertion.sub"
  }

  oidc {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}


data "google_iam_policy" "workload_identity_pool_policy" {
  count = var.use_gha_workload_identity_federation ? 1 : 0
  binding {
    role = "roles/iam.workloadIdentityUser"
    members = [
      "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions_pool[0].workload_identity_pool_id}/attribute.repository_owner/${var.github_organisation}"
    ]
  }
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


# Allow a machine under Workload Identity Federation to act as the given service account.
resource "google_service_account_iam_policy" "workload_identity_service_account_policy" {
  count = var.use_gha_workload_identity_federation ? 1 : 0
  policy_data        = data.google_iam_policy.workload_identity_pool_policy[0].policy_data
  service_account_id = google_service_account.github_actions_service_account.name
  depends_on         = [time_sleep.wait_for_google_apis_to_enable]
}
