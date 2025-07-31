# Project Variables
variable "project" {
  description = "The project in which the resources will be deployed"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region in which the resources will be deployed"
  type        = string
  default     = ""
}

variable "zone" {
  description = "The zone in which the resources will be deployed"
  type        = string
  default     = ""
}

# VPC Variables
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = ""
}

variable "auto_create_subnetworks" {
  description = "Whether to create subnetworks automatically"
  type        = bool
  default     = false
}

# Subnet Variables
variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = ""
}

variable "sub_ip_range" {
  description = "The IP range of the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# GKE Cluster Variables
variable "gke_cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = ""
}

variable "gke_cluster_version" {
  description = "The version of the GKE cluster"
  type        = string
  default     = ""
}

# GKE Node Pool Variables
variable "gke_node_pool_name" {
  description = "The name of the GKE node pool"
  type        = string
  default     = ""
}

variable "gke_node_pool_location" {
  description = "The location of the GKE node pool"
  type        = string
  default     = ""
}

variable "gke_node_pool_node_count" {
  description = "The number of nodes in the GKE node pool"
  type        = number
  default     = 0
}

variable "gke_node_pool_machine_type" {
  description = "The machine type of the GKE node pool"
  type        = string
  default     = ""
}

variable "delete_default_node_pool" {
  description = "Whether to delete the default node pool"
  type        = bool
  default     = true
}

variable "default_node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "cluster_end_point" {
  description = "The endpoint of the GKE cluster"
  type        = bool
  default     = false
}

variable "cluster_private_nodes" {
  description = "The private nodes of the GKE cluster"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "The master ipv4 cidr block"
  type        = string
  default     = ""
}

# Master Authorized Networks
variable "master_authorized_networks" {
  description = "List of CIDR blocks and their display names for master authorized networks"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    {
      cidr_block   = "10.0.0.7/32"
      display_name = "net1"
    }
  ]
}

variable "node_pool_name" {
  description = "The name of the node pool"
  type        = string
  default     = ""

}

variable "node_count" {
  description = "The number of nodes in the node pool"
  type        = number
  default     = 2
}

variable "labels" {
  description = "The labels for the node pool"
  type        = map(string)
  default     = {}
}

variable "gke_internal_ip_type" {
  description = "The type of the internal IP of the GKE cluster"
  type        = string
  default     = ""
}

variable "gke_internal_ip_name" {
  description = "The name of the internal IP of the GKE cluster"
  type        = string
  default     = ""
}

variable "gke_internal_ip_addr" {
  description = "The address of the internal IP of the GKE cluster"
  type        = string
  default     = ""
}

variable "firewall_allow" {
  description = "Firewall allow rules"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
  default = [
    {
      protocol = "tcp"
      ports    = ["22"]
    }
  ]
}

variable "firewall_source_ranges" {
  description = "The source ranges for the firewall rule"
  type        = list(string)
  default     = []
}

variable "fwr_name" {
  description = "The name of the firewall rule"
  type        = string
  default     = ""
}

variable "router_name" {
  description = "The name of the router"
  type        = string
  default     = ""
}

variable "nat_name" {
  description = "The name of the NAT"
  type        = string
  default     = ""
}

