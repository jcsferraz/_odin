# EKS Module

This module creates an Amazon EKS cluster with managed node groups.

## Features

- EKS Cluster with configurable Kubernetes version
- Managed Node Groups with auto-scaling
- IAM roles and policies for cluster and nodes
- Security groups with proper ingress/egress rules
- OIDC provider for service account integration
- EBS CSI driver IAM role for persistent volumes
- Comprehensive logging enabled

## Usage

```hcl
module "eks_cluster" {
  source = "./account/vops-cloud/services/eks/envs/dev/main/src"
  
  cluster_name    = "my-cluster"
  cluster_version = "1.30"
  
  vpc_id             = "vpc-12345678"
  private_subnet_ids = ["subnet-12345678", "subnet-87654321"]
  public_subnet_ids  = ["subnet-abcdefgh", "subnet-hgfedcba"]
  
  node_groups = {
    general = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        max_size     = 4
        min_size     = 1
      }
    }
    spot = {
      instance_types = ["t3.medium", "t3.large"]
      capacity_type  = "SPOT"
      scaling_config = {
        desired_size = 1
        max_size     = 3
        min_size     = 0
      }
    }
  }
  
  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of the EKS cluster | `string` | n/a | yes |
| cluster_version | Kubernetes version for the EKS cluster | `string` | `"1.30"` | no |
| vpc_id | ID of the VPC where the cluster will be created | `string` | n/a | yes |
| private_subnet_ids | List of private subnet IDs | `list(string)` | n/a | yes |
| public_subnet_ids | List of public subnet IDs | `list(string)` | n/a | yes |
| node_groups | Configuration for EKS node groups | `map(object)` | See variables.tf | no |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | EKS cluster ID |
| cluster_arn | EKS cluster ARN |
| cluster_endpoint | Endpoint for EKS control plane |
| cluster_security_group_id | Security group ID attached to the EKS cluster |
| cluster_iam_role_arn | IAM role ARN associated with EKS cluster |
| oidc_provider_arn | The ARN of the OIDC Provider |

## Security

- Cluster endpoint is accessible from both public and private networks
- Node groups are deployed in private subnets only
- Security groups restrict access to VPC CIDR blocks
- IAM roles follow least privilege principle
- All EKS logging types are enabled

## Post-Deployment

After the cluster is created, you can configure kubectl:

```bash
aws eks update-kubeconfig --region us-east-1 --name your-cluster-name
```