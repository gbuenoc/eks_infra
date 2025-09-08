# eks_infra

**Infrastructure as Code for managing Amazon EKS clusters and related AWS resources using Terraform**

---

## Overview

This repository provides Terraform modules and configurations to provision and manage AWS infrastructure for an Amazon EKS (Elastic Kubernetes Service) environment. It includes reusable modules for common components such as VPC setup, EKS cluster provisioning, and Kubernetes add-ons.

---

## Directory Structure

- `vpc/`: Terraform configurations to create networking components, such as VPC, subnets, NAT gateways, and route tables.
- `eks/`: Terraform code to provision the EKS cluster, node groups (managed or self-hosted), IAM roles, and necessary permissions.
- `addons/`: Terraform modules or manifests to install and manage cluster addons (e.g., CNI, metrics server, Kubernetes dashboard, or custom tooling).

---

## Prerequisites

- Terraform v1.0.0 or later
- AWS CLI configured with credentials and a default region
- `kubectl` installed and configured to interact with your EKS cluster
- (Optional) `aws-iam-authenticator` if required by your setup

---

## Usage

1. **Initialize Terraform in each module directory**:

   ```bash
   cd vpc/
   terraform init
   terraform apply

   cd ../eks/
   terraform init
   terraform apply

   cd ../addons/
   terraform init
   terraform apply