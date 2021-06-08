output "external_ip" {
  value = module.lb-http.external_ip
  description = "The IP of the load balancer frontend. This IP is used to reach your Cloud Run backend"
}
