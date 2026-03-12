output "service_url" {
  value = google_cloud_run_service.mathverse_backend.status[0].url
}