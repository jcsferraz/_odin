# _Odin Infrastructure as Code

## Structure

This is how we are implementing IaC at _Odin.

* **One of our premises is that we want the same code as the production environment in our staging/development environment.**

### Folder Structure

```sh
.
├── README.md
├── terraform/
│   ├── backend.tf              # Terraform backend configuration
│   ├── backend-dev.hcl         # Development backend config
│   ├── backend-prod.hcl        # Production backend config
│   ├── providers.tf            # Provider and module configurations
│   ├── variables.tf            # Variable definitions
│   ├── outputs.tf              # Output definitions
│   ├── terraform.tfvars.example # Example variables file
│   └── account/
│       └── vops-cloud/
│           ├── applications/   # Application-specific resources
│           ├── data-stores/    # Shared data stores (DynamoDB, RDS, Redis)
│           ├── network/        # VPC, subnets, networking
│           └── services/       # Shared services (EKS, EC2)
```

## Usage

### 1. Setup

Copy the example variables file and customize:
```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

### 2. Initialize Terraform

For development environment:
```bash
cd terraform
terraform init -backend-config=backend-dev.hcl
```

For production environment:
```bash
cd terraform
terraform init -backend-config=backend-prod.hcl
```

### 3. Plan and Apply

```bash
terraform plan
terraform apply
```

## Environment Configuration

Each environment uses separate backend configurations:
- `backend-dev.hcl` - Development environment
- `backend-prod.hcl` - Production environment

This ensures state isolation between environments while using the same codebase.

## Key Features

- **Multi-environment support** with shared codebase
- **Proper variable validation** for AWS regions and CIDR blocks
- **Modular architecture** for network, data stores, and services
- **EKS cluster configuration** with node groups
- **DynamoDB global tables** for data persistence
- **Comprehensive tagging strategy** for resource management