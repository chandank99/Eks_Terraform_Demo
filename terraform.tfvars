region = "ap-south-1"

cluster_prefix = "Test-cluster"

cluster_version = "1.31"

instance_type = "c7i-flex.large"

node_count = 3

vpc_name = "test-vpc"

vpc_cidr = "10.0.0.0/16"

azs = [
  "ap-south-1a",
  "ap-south-1b",
  "ap-south-1c"
]

public_subnets = [
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24"
]

private_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

enable_nat_gateway = true