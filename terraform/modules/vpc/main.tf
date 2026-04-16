resource "google_compute_network" "vpc" {
  project = var.project_id
  name = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  project = var.project_id
  name = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal"
  project = var.project_id
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  project = var.project_id
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
