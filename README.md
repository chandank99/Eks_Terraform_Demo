# Terraform EKS Demo

This project provisions an Amazon EKS cluster on AWS using Terraform. It creates the complete networking infrastructure, including a VPC, public and private subnets, Internet Gateway, NAT Gateway, route tables, and an Amazon EKS cluster with managed worker nodes.

## Architecture

```
                                 Internet
                                     |
                             Internet Gateway
                                     |
        -------------------------------------------------------
        |                      VPC (10.0.0.0/16)              |
        |                                                     |
        |  Public Subnet A      Public Subnet B      Public Subnet C
        |  10.0.101.0/24        10.0.102.0/24        10.0.103.0/24
        |        |                     |                     |
        |        |                     |                     |
        |        +------ NAT Gateway --+                     |
        |                                                     |
        |-----------------------------------------------------|
        |                                                     |
        |  Private Subnet A     Private Subnet B    Private Subnet C
        |  10.0.1.0/24          10.0.2.0/24         10.0.3.0/24
        |        |                     |                     |
        |        |                     |                     |
        |   Worker Node 1         Worker Node 2        Worker Node 3
        |                                                     |
        |              Amazon EKS Control Plane               |
        -------------------------------------------------------
```

## Infrastructure Components

- Amazon VPC
- 3 Public Subnets
- 3 Private Subnets
- Internet Gateway
- Single NAT Gateway
- Route Tables
- Amazon EKS Cluster
- 3 Amazon EKS Managed Worker Nodes

## Networking

- The VPC is created using the Terraform AWS VPC module.
- Three Availability Zones are used for high availability.
- Public subnets are used for internet-facing resources.
- A single NAT Gateway is deployed in one public subnet.
- Private subnets host the EKS managed worker nodes.
- Worker nodes access the internet through the NAT Gateway for:
  - Pulling container images from Amazon ECR or Docker Hub
  - Downloading operating system updates
  - Accessing AWS APIs

## EKS Cluster

The EKS cluster is created using the official Terraform AWS EKS module.

Features:

- Dynamic cluster name using the current date

  Example:

  ```
  Test-cluster-12072026
  ```

- Configurable Kubernetes version
- Configurable worker node instance type
- Configurable worker node count
- Managed Node Group

## Project Structure

```
terraform-eks/
│── main.tf
│── variables.tf
│── terraform.tfvars
│── outputs.tf
```

## Configuration

The following parameters can be configured using `terraform.tfvars`:

- AWS Region
- Cluster Name Prefix
- Kubernetes Version
- Worker Node Count
- EC2 Instance Type
- VPC CIDR
- Availability Zones
- Public Subnet CIDRs
- Private Subnet CIDRs
- NAT Gateway

## Deploy

Initialize Terraform:

```bash
terraform init
```

Review the execution plan:

```bash
terraform plan
```

Create the infrastructure:

```bash
terraform apply
```

## Destroy

Delete all resources:

```bash
terraform destroy
```

## Notes

- Worker nodes are deployed in **private subnets**.
- Outbound internet connectivity is provided through the **NAT Gateway**.
- The Internet Gateway is attached to the VPC for public subnet access.
- The infrastructure is fully managed through Terraform with no manual AWS resource creation required.