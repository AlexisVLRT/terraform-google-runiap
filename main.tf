resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "cloudrun-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.cloud_run.name
  }
}

resource "google_iap_client" "project_client" {
  display_name = var.brand.application_title
  brand        = var.brand.name
}

data "google_compute_ssl_certificate" "my_cert" {
  name = var.ssl_certificate_name
}

module "lb-http" {
  source               = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version              = "~> 5.1.0"

  ssl                  = true
  ssl_certificates     = [data.google_compute_ssl_certificate.my_cert.self_link]
  use_ssl_certificates = true
  http_forward         = false

  backends = {
    default = {
      protocol = "HTTPS"
      groups = [
        {
          group = google_compute_region_network_endpoint_group.cloudrun_neg.id
        }
      ]

      enable_cdn = false

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      iap_config = {
        enable               = true
        oauth2_client_id     = google_iap_client.project_client.client_id
        oauth2_client_secret = google_iap_client.project_client.secret
      }

      description            = null
      custom_request_headers = null
      security_policy        = null
    }
  }
  name    = "cloud-run-lb"
  project = var.project_id
}
