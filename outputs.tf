# - SRUID for each service revision (or just SUID?)

output "event_store" {
  description = "The full ID of the BigQuery table acting as the Octue services event store."
  value       = google_bigquery_table.octue_service_events_table.table_id
}
