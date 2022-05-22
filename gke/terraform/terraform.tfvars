region                = "europe-west1"
zone                  = "europe-west1-c"

primary_ip_cidr          = "192.168.0.0/26" # max node IPs = 64 (max nodes = 60; 4 IPs reservered in every VPC)
max_pods_per_node        = "32"             # max pods per node <= half of max node IPs
cluster_ipv4_cidr_block  = "10.0.0.0/18"    # max pod IPs = 15360 (60 * 256), CIDR must be able to cover for all the potential IPs
services_ipv4_cidr_block = "10.1.0.0/20"

channel      = "REGULAR"
auto_upgrade = "true"

master_authorized_network_cidr = "93.104.109.121/32"
enable_private_endpoint        = "false"
enable_private_nodes           = "false"

machine_type = "e2-medium"
disk_size_gb = "40"
max_nodes    = "1"

oauth_scopes = [
  "https://www.googleapis.com/auth/cloud-platform", # required for traffic director
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/monitoring",
]

# custom node taints
taint = [
  {
    key    = "node.cilium.io/agent-not-ready"
    value  = "true"
    effect = "NO_SCHEDULE"
  }
]
