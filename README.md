# terraform-google-runiap
Identity-Aware Proxy on Cloud Run. Based on https://github.com/terraform-google-modules/terraform-google-lb 

## Compatibility
This module is tested for use with Terraform 0.14.

## Usage
```hcl
module "lb-iap" {
  source               = "AlexisVLRT/runiap/google"
  project_id           = "my-gcp-project-id"
  region               = "europe-west1"
  ssl_certificate_name = "load-balancer-cert"
  
  # Your Cloud Run Object that you want to protect with IAP
  cloud_run            = google_cloud_run_service.default
  
  # The Brand (OAuth consent screen) of your project
  brand                = google_iap_brand.project_brand
  
  depends_on           = [google_cloud_run_service.default, google_iap_brand.project_brand]
}
```
Fully functional examples are located in the [examples](./examples/) directory.
