resource "google_cloud_run_service" "mathverse_backend" {

  name     = var.service_name
  location = var.region

  template {

    spec {

      containers {

        image = "${var.region}-docker.pkg.dev/${var.project_id}/mathverse-repo/mathverse-backend"

        env {
          name = "GEMINI_API_KEY"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.gemini_api.secret_id
              key  = "latest"
            }
          }
        }

        env {
          name = "FIREBASE_CREDENTIALS"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.firebase_credentials.secret_id
              key  = "latest"
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {

  location = google_cloud_run_service.mathverse_backend.location
  service  = google_cloud_run_service.mathverse_backend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}