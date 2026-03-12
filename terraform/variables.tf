variable "project_id" {
  description = "GCP project id"
}

variable "region" {
  default = "us-central1"
}

variable "service_name" {
  default = "mathverse-backend"
}

variable "gemini_api_key" {
  description = "Gemini API Key"
  sensitive   = true
}