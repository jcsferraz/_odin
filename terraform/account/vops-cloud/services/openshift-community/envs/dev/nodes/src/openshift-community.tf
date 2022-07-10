data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

resource "aws_instance" "openshift-community-nodes-instance" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t3a.medium"
  count           = 4 
  iam_instance_profile = aws_iam_instance_profile.openshift-community-nodes_deploy-ci-cd_server.name
  key_name        = "openshift-community-nodes-dev"
  subnet_id       = "subnet-0a9ba9d2e5dcd203a"
  vpc_security_group_ids = [aws_security_group.openshift-community-nodes-allow-access-sg.id]
  user_data = file("install_openshift-community-nodes.sh")
  

   root_block_device {
           delete_on_termination = "false" 
           encrypted             = "true"
           volume_size           = "30"
           volume_type           = "gp3"

         
  tags = {
    Name = "openshift-community-vol-dev"
    Environment      = "dev"
    Application_ID   = "ec2"
    Application_Role = "Virtual Machines for environment dev"
    Team             = "consulteanuvem-com-br-dev"
    Customer_Group   = "consulteanuvem-dev"
    Resource         = "environment_at_dev"
    kubernetes.io/cluster/community-openshift-cluster = "owned"
  }

        }

  associate_public_ip_address = false // nao associar ip publico na instancia

  tags = {
    Name = "openshift-community-node-dev"
    Environment      = "dev"
    Application_ID   = "ec2"
    Application_Role = "Networking for environment dev"
    Team             = "consulteanuvem-com-br-dev"
    Customer_Group   = "consulteanuvem-dev"
    Resource         = "environment_at_dev"
    kubernetes.io/cluster/community-openshift-cluster = "owned"
   
  }
}

resource "aws_security_group" "openshift-community-nodes-allow-access-sg" {
  name        = "openshift-community-nodes-allow-access-sg"
  description = "allow ssh and openshift-community-nodes inbound traffic"
  vpc_id = var.vpc_nvi
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "rule for allow access in the openshift-community-nodes-api-server  from internal nvi-7-corporate environment"
    cidr_blocks = ["11.0.0.0/16"]
  }
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "rule for allow access in the openshift-community-nodes-api-server  from internal internal-vpcs-jacto-corp environment"
    cidr_blocks = ["11.0.12.0/23"]
  }
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "rule for allow access in the openshift-community-nodes-api-server  from internal internal-vpcs-jacto-corp environment"
    cidr_blocks = ["11.0.10.0/23"]
  }
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "rule for allow access in the openshift-community-nodes-api-server  from internal internal-vpcs-jacto-corp environment"
    cidr_blocks = ["11.0.8.0/23"]
  }
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "rule for allow access in the openshift-community-nodes-api-server  from internal internal-vpcs-jacto-corp environment"
    cidr_blocks = ["11.0.6.0/23"]
  }
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "rule for allow access in the openshift-community-nodes-api-server  from internal internal-vpcs-jacto-corp environment"
    cidr_blocks = ["11.0.4.0/23"]
  }
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "rule for allow access in the openshift-community-nodes-api-server  from internal internal-vpcs-jacto-corp environment"
    cidr_blocks = ["11.0.2.0/23"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    description = "rule for allow access in the openshift-community-nodes-api-server  from internal vpc_nvi environment"
    cidr_blocks     = ["0.0.0.0/0"]
  }

   tags = {
        Name = "openshift-community-nodes-allow-access-sg"
        Environment      = "dev"
        Application_ID   = "vpc"
        Application_Role = "Networking for environment dev"
        Team             = "consulteanuvem-com-br-dev"
        Customer_Group   = "consulteanuvem-dev"
        Resource         = "environment_at_dev" 
        kubernetes.io/cluster/community-openshift-cluster = "owned"
       }

  
}

output "openshift-community-nodes_ip_address" {
  value = aws_instance.openshift-community-nodes-instance.public_dns
}
