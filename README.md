# AWS WordPress Example

This repo contains a basic demo of creating the AWS Infrastructure for EKS to run a WordPress application using Terraform, Helm and Github Actions as CI/CD.

## What is currently configured to be deployed:

- One AWS Account for the Development environment
- One VPC
- Two Public Subnets (Multi-AZ)
- Two Private Subnets (Multi-AZ)
- Internet Gateway
- Two Nat Gateways (One per AZ)
- Route Tables
- Route53
- EKS
- Nginx Ingress Controller
- Prometheus Stack
- WordPress App (5.9.0) 
- CI/CD Pipeline for WordPress App using GitHub Actions (Using the `development` branch)

## Important Notes to run this project

- There is a terraform.auto.tfvars file available with an example of how to set the necessary variables
- There is a pre-configured bucket in the AWS account to store the tfstate. If you want to run this project you need to set the bucket name in the Terraform backend.
- The DNS Zone used in this example is dev.clederson.com, the URLs will be generated for this zone. If you want to configure to your specific zone, you need to change the `domain_name` variable in the tfvars file as well as the `INGRESS_PATH` in the CI/CD workflows
- The CI Workflow will run on every pull request
- The CD Workflow is configured to trigger based on any changes in the `development` branch
- Prometheus Stack is deployed using the default values, so it is only available inside of the cluster
- To set the Github Action workflows to upgrade the application deployment is necessary to set the secrets as the example below:

| Name                    | Description                                                                                                                                                                                                       |
| ------------------------| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `AWS_ACCESS_KEY_ID`     | The ID of your AWS Key                                                                                                                                                                                            |
| `AWS_SECRET_ACCESS_KEY` | The secret of your AWS Key                                                                                                                                                                                        |
| `AWS_REGION`            | The AWS Region where you will deploy your resources                                                                                                                                                               |
| `AWS_EKS_CLUSTER`       | The name of your EKS Cluster                                                                                                                                                                                      |
| `MARIADB_PASSWORD`      | The password used for the DB, you can get this from the K8s cluster with: `kubectl get secret --namespace <namespacename> my-wordpress-mariadb -o jsonpath="{.data.mariadb-password}" \| base64 --decode`           |
| `MARIADB_ROOT_PASSWORD` | The root password used for the DB, you can get this from the K8s cluster with: `kubectl get secret --namespace <namespacename> my-wordpress-mariadb -o jsonpath="{.data.mariadb-root-password}" \| base64 --decode` |
| `WORDPRESS_PASSWORD`    | The password used for WordPress, you can get this from the K8s cluster with: `kubectl get secret --namespace <namespacename> my-wordpress -o jsonpath="{.data.wordpress-password}" \| base64 --decode`      |

## What can be improved in this project:

- Https for Ingress (Cert-Manager)
- RDS with a separated private subnet (Currently using MariaDB as a pod)
- Deploy Secret Manager to store sensitive data
- Separeted service account for GitHub Actions
- K8s volumes to be used by Prometheus
- CI/CD for Terraform
- OpenID to Connect in AWS for GitHub Actions
- Create the Staging and Production environment and set the workflows as was done for the development