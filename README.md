# Amazon EKS Cluster Provisioning using Terraform

This project provisions a complete Amazon Elastic Kubernetes Service (EKS) environment on AWS using Terraform. It creates a custom VPC, networking components, an EKS control plane, and managed worker nodes following AWS best practices.

---

# Architecture

## AWS Infrastructure

```text
                         Internet
                             │
                    +----------------+
                    | Internet Gateway|
                    +----------------+
                             │
               ┌─────────────┴─────────────┐
               │                           │
        Public Subnets              Public Subnets
       (ap-south-1a/b/c)          (ELB / NAT Gateway)
               │
        +--------------+
        | NAT Gateway  |
        +--------------+
               │
               ▼
      Private Subnets (3 AZs)
               │
        Amazon EKS Worker Nodes
```

---

## Kubernetes Architecture

```text
                     kubectl
                        │
                        │
        EKS Public API Endpoint
                        │
         +---------------------------+
         |      EKS Control Plane     |
         +---------------------------+
                    │
      ┌─────────────┴─────────────┐
      │                           │
+-------------+             +-------------+
| Worker Node |             | Worker Node |
+-------------+             +-------------+
      │                           │
   Kubernetes Pods          Kubernetes Pods
```

* Kubernetes API is accessible from your local machine.
* Worker nodes are deployed in **private subnets**.
* Applications are exposed using an AWS Load Balancer or Ingress.

---

# Features

* Amazon EKS Cluster
* Managed Node Group
* Custom VPC
* Public & Private Subnets
* NAT Gateway
* Internet Gateway
* Public and Private Kubernetes API Endpoint
* Cluster Creator Admin Permissions
* Configurable Kubernetes Version
* Configurable Node Count
* Configurable EC2 Instance Type
* Terraform Outputs

---

# Project Structure

```text
.
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── README.md
```

---

# Prerequisites

Install the following tools before deploying the infrastructure:

* Terraform (>= 1.5)
* AWS CLI v2
* kubectl
* eksctl (optional)

Configure AWS credentials:

```bash
aws configure
```

Verify your identity:

```bash
aws sts get-caller-identity
```

The IAM user or role should have permissions to create EKS, VPC, EC2, IAM, CloudWatch, and KMS resources.

---

# Configuration

Update `terraform.tfvars` according to your requirements.

Example:

```hcl
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
```

---

# Cluster Naming

The cluster name is generated dynamically using the current date.

Example:

```text
Test-cluster-12072026
```

The name uses the format:

```text
<cluster-prefix>-DDMMYYYY
```

> **Note:** Because the cluster name includes the current date, running `terraform apply` on a different day will generate a new cluster name. Terraform will therefore plan to create a new EKS cluster.

---

# Deploy the Infrastructure

Initialize Terraform:

```bash
terraform init
```

Review the execution plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Terraform creates:

* VPC
* Public Subnets
* Private Subnets
* NAT Gateway
* Security Groups
* IAM Roles
* Amazon EKS Cluster
* Managed Node Group

---

# Terraform Outputs

After a successful deployment, Terraform displays:

* Cluster Name
* Cluster Endpoint
* VPC ID

Example:

```text
cluster_name = Test-cluster-12072026

cluster_endpoint = https://xxxxxxxx.gr7.ap-south-1.eks.amazonaws.com

vpc_id = vpc-xxxxxxxx
```

---

# Configure kubectl (Required)

After the cluster has been created, update your local Kubernetes configuration.

Run:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name <cluster-name>
```

Example:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name Test-cluster-12072026
```

Verify that the context has been updated:

```bash
kubectl config current-context
```

Verify the worker nodes:

```bash
kubectl get nodes
```

Expected output:

```text
NAME                     STATUS   ROLES    AGE
ip-10-0-1-10             Ready    <none>   2m
ip-10-0-2-20             Ready    <none>   2m
ip-10-0-3-15             Ready    <none>   2m
```

> **Important:** Until you update the kubeconfig, `kubectl` cannot communicate with your newly created EKS cluster.

---

# Verify the Deployment

Verify the cluster:

```bash
eksctl get cluster
```

Verify managed node groups:

```bash
eksctl get nodegroup --cluster <cluster-name>
```

List Kubernetes nodes:

```bash
kubectl get nodes
```

---

# Destroy the Infrastructure

To remove all resources:

```bash
terraform destroy
```

---

# Notes

* Worker nodes are deployed inside **private subnets**.
* Kubernetes API is accessible through the public endpoint.
* Applications should be exposed using Kubernetes `Service` of type `LoadBalancer` or an Ingress Controller.
* The EKS API endpoint is intended for Kubernetes clients such as `kubectl`; it is not a web application and should not be opened directly in a browser.
* Cluster creator admin permissions are enabled, allowing the IAM principal that provisions the cluster to access it using `kubectl`.
* Destroy AWS resources when they are no longer required to avoid unnecessary charges.

---

# License

This project is intended for learning and demonstration purposes.
