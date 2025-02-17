locals {
  developer_service_account_emails = toset(
    [
      for account in google_service_account.developers : "serviceAccount:${account.email}"
    ]
  )
}


resource "google_project_iam_member" "developers__iam__service_account_user" {
  for_each   = local.developer_service_account_emails
  project    = var.google_cloud_project_id
  role       = "roles/iam.serviceAccountUser"
  member     = each.value
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "developers__pub_sub__editor" {
  for_each   = local.developer_service_account_emails
  project    = var.google_cloud_project_id
  role       = "roles/pubsub.editor"
  member     = each.value
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "developers__error_reporting__writer" {
  for_each   = local.developer_service_account_emails
  project    = var.google_cloud_project_id
  role       = "roles/errorreporting.writer"
  member     = each.value
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "developers__bigquery__data_viewer" {
  for_each   = local.developer_service_account_emails
  project    = var.google_cloud_project_id
  role       = "roles/bigquery.dataViewer"
  member     = each.value
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "developers__bigquery__job_user" {
  for_each   = local.developer_service_account_emails
  project    = var.google_cloud_project_id
  role       = "roles/bigquery.jobUser"
  member     = each.value
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "developers__bigquery__read_session_user" {
  for_each   = local.developer_service_account_emails
  project    = var.google_cloud_project_id
  role       = "roles/bigquery.readSessionUser"
  member     = each.value
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "developers__storage__admin" {
  for_each = local.developer_service_account_emails
  project  = var.google_cloud_project_id
  role     = "roles/storage.admin"
  member   = each.value
}


resource "google_project_iam_member" "developers__artifact_registry__writer" {
  for_each = local.developer_service_account_emails
  project  = var.google_cloud_project_id
  role     = "roles/artifactregistry.writer"
  member   = each.value
}


resource "google_storage_bucket_iam_member" "developers__default_bucket__storage__admin" {
  for_each = local.developer_service_account_emails
  bucket   = google_storage_bucket.default.name
  role     = "roles/storage.admin"
  member   = each.value
}
