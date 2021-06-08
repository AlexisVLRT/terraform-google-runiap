variable "project_id" {
  type        = string
  description = "Project ID. Might be different from the project name."
}

variable "region" {
  type = string
  description = "Compute region like \"europe-west1\" or \"us-central1\""
}

variable "cloud_run" {
  description = "Your google_cloud_run_service resource"
}

variable "brand" {
  description = "Your google_iap_brand resource"
}

variable "ssl_certificate_name" {
  type        = string
  description = "The name of your SSL certificate to be used for HTTPS on the load balancer frontend. You will need a domain name and the associated SSL cert to deploy IAP on Cloud Run"
}
