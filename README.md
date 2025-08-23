# WE-Final-Project

This project sets up a highly available AWS infrastructure using Terraform, featuring a VPC with public and private subnets across multiple availability zones, an Application Load Balancer, Auto Scaling group, Amazon EFS for shared storage, and an Amazon Aurora database cluster.

---

## Architecture Overview

![IMG-20250822-WA0004](https://github.com/user-attachments/assets/1823971c-009e-4281-87f7-680ecf23facf)


### The infrastructure includes:

-  VPC with public and private subnets across two availability zones

-  NAT Gateways for outbound internet access from private subnets

-  Application Load Balancer for distributing traffic to app servers

-  Auto Scaling Group for automatically scaling app servers

-  Amazon EFS for shared file storage with mount targets in each private subnet

-  Amazon Aurora database cluster with primary and replica instances

-  Security Groups for controlling network traffic between components

---

## File Structure:
```
.
├── main.tf                 # Core Terraform configuration
├── variables.tf            # Input variable definitions
├── outputs.tf             # Output values
├── terraform.tfvars       # Variable values (not committed to version control)
├── data.tf                # Data sources (AMI, availability zones)
├── variables.tf            # Input variable definitions
├── outputs.tf             # Output values
├── terraform.tfvars       # Variable values (not committed to GitHub)
├── networking.tf          # VPC, subnets, and networking components
├── alb.tf                 # Application Load Balancer configuration
├── autoscaling.tf         # Auto Scaling Group and Launch Template
├── efs.tf                 # EFS file system and mount targets
├── aurora.tf              # Aurora database cluster
├── security_groups.tf     # Security group definitions
└── data.tf                # Data sources (AMI, availability zones)
└── security_groups.tf     # Security group definitions
```
---

## Prerequisites:

-  Terraform 1.0+ installed

-  AWS account with appropriate permissions

-  AWS CLI configured with credentials

---

## Usage:
-  Clone this repository:
```
git clone https://github.com/AhmedSabeh/WE-Final-Project
cd WE-Final-Project
```

-  Initialize Terraform:
```
terraform init
```
-  Review the execution plan:
```
terraform plan
```
-  Apply the configuration:
```
terraform apply
```

-  When prompted, confirm the action by typing yes

---

## Input Variables
-  Create a terraform.tfvars file with the following variables:
```
db_username = "your_db_username"
db_password = "your_secure_password"
```
-  Note: Never commit the terraform.tfvars file to version control as it may contain sensitive information.

## Outputs

-  After successful deployment, Terraform will output:

-  ALB DNS name (for accessing the application)

-  Database endpoint (for database connections)

---

## Cleaning Up

-  To destroy all created resources:
```
terraform destroy
```
