resource "google_cloud_run_service" "default" {
  name     = "cloudrun-service"
  location = "europe-west1"

  metadata {
    annotations = {
      "run.googleapis.com/ingress"        = "internal-and-cloud-load-balancing"
      "run.googleapis.com/ingress-status" = "internal-and-cloud-load-balancing"
    }
  }

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  autogenerate_revision_name = true

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_iap_brand" "project_brand" {
  support_email     = "alice@example.com"
  application_title = "IAP-protected-cloud-run"
}

module "lb-iap" {
  depends_on           = [google_cloud_run_service.default, google_iap_brand.project_brand]
  source               = "AlexisVLRT/runiap/google"
  project_id           = var.project_id
  region               = "europe-west1"
  ssl_certificate_name = "load-balancer-cert"
  cloud_run            = google_cloud_run_service.default
  brand                = google_iap_brand.project_brand
}

resource "google_iap_web_iam_member" "member" {
  role   = "roles/iap.httpsResourceAccessor"
  member = "user:jane@example.com"
}
