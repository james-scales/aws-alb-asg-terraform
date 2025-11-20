# Class 7 Project
# AWS Load Balancer & ASG Architecture with Terraform (Simple)

## Overview
Currently this is an ongoing project building an AWS networking infrastructure. This is the foundation of what will become a fully functional Load Balancing & Auto-scaling group built out in Terraform. 

## Prerequisites
1. Have an AWS account
2. Have AWS credentials 
3. Have a user data script for your EC2 instance
4. Have a .gitignore file
5. Install VS Code and open with your project
6. Open GitBash in VS Code

### Architecture
![alt text](aws-infrastructure.png)


### User Data Shell Script
Example user data script if not available

```bash
curl -O https://raw.githubusercontent.com/aaron-dm-mcdonald/Class7-notes/refs/heads/main/110225/user_data.sh
```
### Steps
## Authentication
    + Create provider block with Region
    + Create terraform block w/ required providers with source (aws) and version

## VPC
    + Create vpc resource with CIDR block, enable DNS hostnames & support
## Subnets
    + Create subnet resources.
        + Create CIDR Block
        + Create AZ
        + Link to custom VPC
        + Map Public IP for PUBLIC subnets
## Gateway Resources
    + Create Internet Gateway resource
        + Link VPC
    + Create EIP for NAT Gateway
        + Include Domain = VPC
        + Include "depends_on" attribute for IGW
    + Create NAT Gateway resource
        + Allocation ID for EIP
        + Link one Public Subnet
        + Include "depends_on" attribute for IGW
## Route Tables
    + Create Public & Private Route Table resource
        + Link VPC
        + Create Route sub block
            + CIDR Block - Anywhere
            + Link IGW (Public) or NAT (Private)
    + Create Public & Private Route Table Association resource
        + Create route table association for each subnet created with public or private route table.
## Security Group
    + Create Security Group resource
        + Create security group for web server
            + Give name and description
            + Link VPC
        + Create ingress rule (HTTP)
            + Link created Security Group resource
            + from Port 80
            + Protocol TCP
            + to Port 80
        + Create ingress rule (SSH)
            + CIDR Block - Give VPC CIDR
            + from Port 22
            + Protocol TCP
            + to Port 22
        + Create egress rule
            + CIDR - Anywhere
            + IP Protocol - -1
        + Create security group for Load Balancer
            + Give name and description
            + Link VPC
        + Create ingress rule (HTTP)
            + CIDR Block - Anywhere
            + from Port 80
            + Protocol TCP
            + to Port 80
## Launch Template
    + Will finish!!!




