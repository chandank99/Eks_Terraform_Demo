variable "region" {
  type = string
}

variable "cluster_prefix" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "node_count" {
  type = number
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type = bool
}