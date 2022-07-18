vpc_cidr   = "172.32.0.0/16"
public_subnets = [
  "172.32.10.0/24",
  "172.32.11.0/24",
]
private_subnets = [
  "172.32.0.0/24",
  "172.32.1.0/24",
]
environment             = "dev"
product                 = "demo-app"
account_id              = "012345678901" #Fake number to give an example 
region                  = "us-east-1"
enable_dns_hostnames    = true
enable_dns_support      = true
map_public_ip_on_launch = true
domain_name             = "clederson.com" #Example using my personal domain