resource "google_compute_global_address" "k8s-public-ip" {
  name = "k8s-public-ip"
}

resource "google_dns_record_set" "k8s_public_zone_dns" {
  project      = var.project_id
  managed_zone = google_dns_managed_zone.k8s_public_zone.name
  name         = var.domain_name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_address.k8s-public-ip.id]
}

resource "google_dns_managed_zone" "k8s_public_zone" {
  dns_name    = var.domain_name
  name        = var.domain_name
  description = var.domain_name
}
