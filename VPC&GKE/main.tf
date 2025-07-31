# create VPC
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  project                 = var.project
  auto_create_subnetworks = var.auto_create_subnetworks
}

# Create Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  project       = var.project
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.sub_ip_range
}

# # Create Service Account
# resource "google_service_account" "mysa" {
#   account_id   = "mysa"
#   display_name = "Service Account for GKE nodes"
# }


# Create GKE cluster with 2 nodes in our custom VPC/Subnet
resource "google_container_cluster" "primary" {
  name                     = var.gke_cluster_name
  project                  = var.project
  location                 = var.zone
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name
  remove_default_node_pool = var.delete_default_node_pool ## create the smallest possible default node pool and immediately delete it.
  initial_node_count       = var.default_node_count

  private_cluster_config {
    enable_private_endpoint = var.cluster_end_point
    enable_private_nodes    = var.cluster_private_nodes
    # master_ipv4_cidr_block  = "10.13.0.0/28"
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.11.0.0/21"
    services_ipv4_cidr_block = "10.12.0.0/21"
  }
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }
}

# Create managed node pool
resource "google_container_node_pool" "primary_nodes" {
  name       = var.node_pool_name
  project    = var.project
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels       = var.labels
    machine_type = var.gke_node_pool_machine_type
    preemptible  = true
    #service_account = google_service_account.mysa.email

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}



## Create jump host . We will allow this jump host to access GKE cluster. the ip of this jump host is already authorized to allowin the GKE cluster

resource "google_compute_address" "gke_internal_ip_addr" {
  project      = var.project
  address_type = var.gke_internal_ip_type
  region       = var.region
  subnetwork   = google_compute_subnetwork.subnet.name
  name         = var.gke_internal_ip_name
  address      = var.gke_internal_ip_addr
  description  = "An internal IP address for my jump host"
}

resource "google_compute_instance" "default" {
  project      = var.project
  zone         = var.zone
  name         = "jump-host"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network            = google_compute_network.vpc.name
    subnetwork         = google_compute_subnetwork.subnet.name # Replace with a reference or self link to your subnet, in quotes
    subnetwork_project = var.project
    network_ip         = google_compute_address.gke_internal_ip_addr.address
  }

}


## Creare Firewall to access jump hist via iap


resource "google_compute_firewall" "rules" {
  project = var.project
  name    = var.fwr_name
  network = google_compute_network.vpc.name # Replace with a reference or self link to your network, in quotes

  dynamic "allow" {
    for_each = var.firewall_allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
  source_ranges = var.firewall_source_ranges
}



## Create IAP SSH permissions for your test instance

resource "google_project_iam_member" "project" {
  project = var.project
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:sa-terrafrom@${var.project}.iam.gserviceaccount.com"
}

# create cloud router for nat gateway
resource "google_compute_router" "router" {
  project = var.project
  name    = var.router_name
  network = google_compute_network.vpc.name
  region  = var.region
}

## Create Nat Gateway with module

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = var.project
  region     = var.region
  router     = google_compute_router.router.name
  name       = var.nat_name

}
