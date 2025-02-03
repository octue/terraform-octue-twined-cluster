resource "google_project_iam_member" "github_actions__roles" {
  for_each = toset(
    [
      "roles/iam.serviceAccountUser",
      "roles/pubsub.editor",
      "roles/errorreporting.writer",
      "roles/artifactregistry.writer",
      "roles/storage.objectAdmin",
      # Allows the GHA to call "namespaces get" for Cloud Run to determine the resulting run URLs of the services.
      # This should also allow a service to get its own name by using:
      #   https://stackoverflow.com/questions/65628822/google-cloud-run-can-a-service-know-its-own-url/65634104#65634104
      "roles/run.developer",
    ]
  )
  project    = var.google_cloud_project_id
  role       = each.value
  member     = "serviceAccount:${google_service_account.github_actions_service_account.email}"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "pubsub_service__bigquery__data_editor" {
  project    = var.google_cloud_project_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "cloud_build__service_agent" {
  project    = var.google_cloud_project_id
  role       = "roles/cloudbuild.serviceAgent"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "cloud_build__service_usage_consumer" {
  project    = var.google_cloud_project_id
  role       = "roles/serviceusage.serviceUsageConsumer"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "cloud_functions__service_agent" {
  project    = var.google_cloud_project_id
  role       = "roles/cloudfunctions.serviceAgent"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcf-admin-robot.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}


resource "google_project_iam_member" "cloud_functions__service_usage_consumer" {
  project    = var.google_cloud_project_id
  role       = "roles/serviceusage.serviceUsageConsumer"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcf-admin-robot.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}
