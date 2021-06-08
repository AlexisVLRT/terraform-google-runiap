terraform {
  required_version = "> 0.13.2"
}

provider "google" {
  project = var.project_id
}