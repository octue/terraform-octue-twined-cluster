resource "google_pubsub_topic" "services_topic" {
  name       = "${var.environment}.octue.twined.services"
  depends_on = [time_sleep.wait_for_google_apis_to_enable]
}
