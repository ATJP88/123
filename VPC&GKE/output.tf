############Output############################################
output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "VPC Name"
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "Subnet Name"
}

output "cluster_node_name" {
  value       = google_container_node_pool.primary_nodes.name
  description = "GKE Cluster Node Pool Name"
}

output "static_ip_address" {
  value       = google_compute_address.gke_internal_ip_addr.address
  description = "GKE Static IP Address"
}

output "google_compute_instance" {
  value       = google_compute_instance.default.self_link
  description = "Jump Host Instance"
}
