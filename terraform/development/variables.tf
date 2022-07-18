variable "access_key" {
  description = "Access to connect on AWS"
  type        = string
}

variable "secret_key" {
  description = "Access to connect on AWS"
  type        = string
}


variable "vpc_cidr" {
  description = "Main VPC CIDR Block"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets CIDRs"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of private (egress only) subnets CIDRs"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name for tagging purposes (e.g. development, stage or production)"
  type        = string
}

variable "product" {
  description = "Main identifier of the product"
}

variable "single_natgw" {
  description = "Should be true if you want to provision a single shared NAT Gateway for all your private networks"
  type        = bool
  default     = false
}

variable "dual_az_only" {
  description = "Activate environments on 2 AZs only (spans across all of them if FALSE)"
  type        = bool
  default     = false
}

variable "account_id" {
  description = "Account ID to use on roles and policies"
  type        = string
}


variable "region" {
  description = "Region where the resources will be deployed"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP for resources launched on public subnets"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "The DNS Domain name of the zone that will be created"
  type        = string
}