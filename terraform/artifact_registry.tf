resource "google_artifact_registry_repository" "mathverse_repo" {

  location      = var.region
  repository_id = "mathverse-repo"
  description   = "Docker repository for MathVerse"
  format        = "DOCKER"
}