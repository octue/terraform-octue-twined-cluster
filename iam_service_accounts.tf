resource "google_service_account" "github_actions_service_account" {
    account_id   = "github-actions"
    description  = "Allow GitHub Actions to test Octue services."
    display_name = "github-actions"
    project      = var.google_cloud_project_id
}


resource "google_service_account" "admin_accounts" {
    for_each = var.service_account_names
    account_id   = each.key
    display_name = each.key
    project      = var.google_cloud_project_id
    description  = "Allow ${each.key} to access most resources related to Octue services"
}
