resource "google_secret_manager_secret" "gemini_api" {
  secret_id = "gemini-api-key"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "gemini_api_version" {
  secret      = google_secret_manager_secret.gemini_api.id
  secret_data = var.gemini_api_key
}

resource "google_secret_manager_secret" "firebase_credentials" {
  secret_id = "firebase-credentials"

  replication {
    automatic = true
  }
}