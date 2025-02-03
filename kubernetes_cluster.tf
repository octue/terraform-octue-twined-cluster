resource "google_container_cluster" "primary" {
  name             = "${var.environment}-octue-twined-cluster"
  location         = var.google_cloud_region
  enable_autopilot = true

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.kubernetes.email
    }
  }

  deletion_protection = var.deletion_protection
  depends_on          = [time_sleep.wait_for_google_apis_to_enable]
}


resource "time_sleep" "wait_for_cluster_to_be_ready" {
  depends_on      = [google_container_cluster.primary]
  create_duration = "2m"
}
