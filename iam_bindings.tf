locals {
  admin_service_account_emails = [
    for account in google_service_account.admin_accounts : "serviceAccount:${account.email}"
  ]

  all_service_account_emails = concat(
    ["serviceAccount:${google_service_account.github_actions_service_account.email}"],
    local.admin_service_account_emails
  )
}


resource "google_project_iam_binding" "iam_serviceaccountuser" {
  project = var.google_cloud_project_id
  role    = "roles/iam.serviceAccountUser"
  members = local.all_service_account_emails
}


resource "google_project_iam_binding" "pubsub_editor" {
  project = var.google_cloud_project_id
  role    = "roles/pubsub.editor"
  members = local.all_service_account_emails
}


# Allows the GHA to call "namespaces get" for Cloud Run to determine the resulting run URLs of the services.
# This should also allow a service to get its own name by using:
#   https://stackoverflow.com/questions/65628822/google-cloud-run-can-a-service-know-its-own-url/65634104#65634104
resource "google_project_iam_binding" "run_developer" {
  project = var.google_cloud_project_id
  role    = "roles/run.developer"
  members = [
    "serviceAccount:${google_service_account.github_actions_service_account.email}",
  ]
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "artifactregistry_writer" {
  project = var.google_cloud_project_id
  role    = "roles/artifactregistry.writer"
  members = [
    "serviceAccount:${google_service_account.github_actions_service_account.email}",
  ]
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "storage_objectadmin" {
  project = var.google_cloud_project_id
  role    = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.github_actions_service_account.email}",
  ]
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "errorreporting_writer" {
  project    = var.google_cloud_project_id
  role       = "roles/errorreporting.writer"
  members    = local.all_service_account_emails
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "bigquery_dataeditor" {
  project = var.google_cloud_project_id
  role    = "roles/bigquery.dataEditor"
  members = [
    "serviceAccount:service-${var.google_cloud_project_number}@gcp-sa-pubsub.iam.gserviceaccount.com",
  ]
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "bigquery_dataviewer" {
  project    = var.google_cloud_project_id
  role       = "roles/bigquery.dataViewer"
  members    = local.admin_service_account_emails
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "bigquery_jobuser" {
  project    = var.google_cloud_project_id
  role       = "roles/bigquery.jobUser"
  members    = local.admin_service_account_emails
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_binding" "bigquery_readsessionuser" {
  project    = var.google_cloud_project_id
  role       = "roles/bigquery.readSessionUser"
  members    = local.admin_service_account_emails
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}
