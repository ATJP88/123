vpc_name                   = "vpc-gke"
subnet_name                = "subnet1"
auto_create_subnetworks    = false
project                    = "cultivated-link-446913-u8"
region                     = "us-central1"
zone                       = "us-central1-a"
gke_cluster_name           = "hipster-gke-cluster"
gke_cluster_version        = "1.20.9-gke.1001"
gke_node_pool_machine_type = "n1-standard-1"
default_node_count         = 1
delete_default_node_pool   = true



master_authorized_networks = [
  {
    cidr_block   = "10.0.0.7/32"
    display_name = "net1"
  },
  {
    cidr_block   = "10.0.1.0/24"
    display_name = "net2"
  }
]

labels = {
  "env" = "dev"
}

gke_internal_ip_type = "INTERNAL"
gke_internal_ip_name = "gke-internal-ip"
gke_internal_ip_addr = "10.0.1.7"

firewall_allow = [
  {
    protocol = "tcp"
    ports    = ["22"]
  }
]

firewall_source_ranges = ["35.235.240.0/20"]
fwr_name               = "allow-ssh"
router_name            = "gke-router"
nat_name               = "nat-config"

cluster_end_point     = false
cluster_private_nodes = false
node_pool_name        = "hipster-node-pool"

