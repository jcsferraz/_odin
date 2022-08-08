data "aws_iam_policy_document" "eks-consulteanuvem-dev-cluster" {

    version = "2012-10-17"

    statement {

        actions = [
            "sts:AssumeRole"
        ]

        principals {
            type = "Service"
            identifiers = ["eks.amazonaws.com"]
        }      
    
    }  

}

resource "aws_iam_role" "eks-consulteanuvem-dev-cluster" {
        name = format("%s-eks-consulteanuvem-dev-cluster", var.cluster_name)
        assume_role_policy = data.aws_iam_policy_document.eks-consulteanuvem-dev-cluster.json

    }

resource "aws_iam_role_policy_attachment" "eks-consulteanuvem-dev-cluster_cluster" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks-consulteanuvem-dev-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-consulteanuvem-dev-cluster_service" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role = aws_iam_role.eks-consulteanuvem-dev-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-consulteanuvem-dev-cluster_cni" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eks-consulteanuvem-dev-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-consulteanuvem-dev-cluster_worker" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.eks-consulteanuvem-dev-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-consulteanuvem-dev-cluster_agent-gw" {
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    role = aws_iam_role.eks-consulteanuvem-dev-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-consulteanuvem-dev-cluster_ecr-read" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks-consulteanuvem-dev-cluster.name
}


data "aws_iam_policy_document" "node-consulteanuvem-dev" {
  statement {
        effect = "Allow"
        actions = ["sts:AssumeRole",

]

        principals {
            type =  "Service"
            identifiers = ["ec2.amazonaws.com", "codepipeline.amazonaws.com", "codebuild.amazonaws.com"]
}

        }
    }

resource "aws_iam_role" "node-consulteanuvem-dev" {
        name = format("%s-node-consulteanuvem-dev", var.cluster_name)
        assume_role_policy = data.aws_iam_policy_document.node-consulteanuvem-dev.json

    }

resource "aws_iam_role_policy_attachment" "node-consulteanuvem-dev_cluster" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.node-consulteanuvem-dev.name
}

resource "aws_iam_role_policy_attachment" "node-consulteanuvem-dev_service" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role = aws_iam_role.node-consulteanuvem-dev.name
}

resource "aws_iam_role_policy_attachment" "node-consulteanuvem-dev_cni" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.node-consulteanuvem-dev.name
}

resource "aws_iam_role_policy_attachment" "node-consulteanuvem-dev_worker" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.node-consulteanuvem-dev.name
}

resource "aws_iam_role_policy_attachment" "node-consulteanuvem-dev_agent-gw" {
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    role = aws_iam_role.node-consulteanuvem-dev.name
}

resource "aws_iam_role_policy_attachment" "node-consulteanuvem-dev_ecr-read" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.node-consulteanuvem-dev.name
}

resource "aws_iam_policy" "node-consulteanuvem-dev_anothers_policy" {
  name        = "node-consulteanuvem-dev_anothers-group_policy"
  description = "policy full resources to api-gw,mq,ssm,cognito,xray,appmesh,service-discovery,s3,prometheus,kafka,lambda,elbs-albs-nlbs,sqs,asgs in your behalf."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "sqs:*",
                "mq:*",
                "dynamodb:*",
                "lambda:*",
                "kafka:*",
                "logs:*",
                "cognito-identity:*",
                "cognito-idp:*",
                "cognito-sync:*",
                "aps:*",
                "s3:*",
                "ssm:*",
                "execute-api:*",
                "servicediscovery:CreateService",
                "servicediscovery:DeleteService",
                "servicediscovery:GetService",
                "servicediscovery:GetInstance",
                "servicediscovery:RegisterInstance",
                "servicediscovery:DeregisterInstance",
                "servicediscovery:ListInstances",
                "servicediscovery:ListNamespaces",
                "servicediscovery:ListServices",
                "servicediscovery:GetInstancesHealthStatus",
                "servicediscovery:UpdateInstanceCustomHealthStatus",
                "servicediscovery:GetOperation",
                "route53:GetHealthCheck",
                "route53:CreateHealthCheck",
                "route53:UpdateHealthCheck",
                "route53:ChangeResourceRecordSets",
                "route53:DeleteHealthCheck",
                "appmesh:*",
                "xray:PutTraceSegments",
                "xray:PutTelemetryRecords",
                "xray:GetSamplingRules",
                "xray:GetSamplingTargets",
                "xray:GetSamplingStatisticSummaries",
                "elasticloadbalancing:ModifyListener",
                "ec2:DescribeInstances",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeTags",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions",
                "iam:ListServerCertificates",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:SetIpAddressType",
                "ec2:DescribeInternetGateways",
                "elasticloadbalancing:SetWebACL",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:SetWebAcl",
                "waf-regional:GetWebACLForResource",
                "elasticloadbalancing:DescribeLoadBalancers",
                "acm:GetCertificate",
                "waf-regional:GetWebACL",
                "elasticloadbalancing:CreateRule",
                "ec2:DescribeAccountAttributes",
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "waf:GetWebACL",
                "iam:GetServerCertificate",
                "ec2:CreateTags",
                "ec2:ModifyNetworkInterfaceAttribute",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeregisterTargets",
                "ec2:RevokeSecurityGroupIngress",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "acm:DescribeCertificate",
                "elasticloadbalancing:ModifyRule",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:DescribeRules",
                "ec2:DescribeSubnets",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "waf-regional:AssociateWebACL",
                "tag:GetResources",
                "ec2:DescribeAddresses",
                "ec2:DeleteTags",
                "elasticloadbalancing:RemoveListenerCertificates",
                "tag:TagResources",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:CreateListener",
                "ec2:DescribeNetworkInterfaces",
                "elasticloadbalancing:DescribeListeners",
                "ec2:CreateSecurityGroup",
                "acm:ListCertificates",
                "elasticloadbalancing:DescribeListenerCertificates",
                "ec2:ModifyInstanceAttribute",
                "elasticloadbalancing:DeleteRule",
                "ec2:DescribeInstanceStatus",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:CreateLoadBalancer",
                "waf-regional:DisassociateWebACL",
                "ec2:DescribeTags",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:*",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:DeleteTargetGroup",
                "ec2:DescribeSecurityGroups",
                "iam:CreateServiceLinkedRole",
                "ec2:DescribeVpcs",
                "ec2:DeleteSecurityGroup",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:DeleteListener"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "node-consulteanuvem-dev_wafv2_policy" {
  name        = "node-consulteanuvem-dev_wafv2-group_policy"
  description = "policy full resources to api wafv2 in your behalf."

 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "acm:DescribeCertificate",
                "acm:ListCertificates",
                "acm:GetCertificate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcs",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteRule",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:ModifyRule",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:SetIpAddressType",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:SetWebACL"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole",
                "iam:GetServerCertificate",
                "iam:ListServerCertificates"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cognito-idp:DescribeUserPoolClient"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "waf-regional:GetWebACLForResource",
                "waf-regional:GetWebACL",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "tag:GetResources",
                "tag:TagResources"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "waf:GetWebACL"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "wafv2:GetWebACL",
                "wafv2:GetWebACLForResource",
                "wafv2:AssociateWebACL",
                "wafv2:DisassociateWebACL"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "shield:DescribeProtection",
                "shield:GetSubscriptionState",
                "shield:DeleteProtection",
                "shield:CreateProtection",
                "shield:DescribeSubscription",
                "shield:ListProtections"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "node-consulteanuvem-dev_elbsv2_policy" {
  name        = "node-consulteanuvem-dev_elbsv2-group_policy"
  description = "policy full resources to api elbsv2 in your behalf."

 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeVpcs",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeInstances",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeTags",
                "ec2:GetCoipPoolUsage",
                "ec2:DescribeCoipPools",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DescribeTags"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cognito-idp:DescribeUserPoolClient",
                "acm:ListCertificates",
                "acm:DescribeCertificate",
                "iam:ListServerCertificates",
                "iam:GetServerCertificate",
                "waf-regional:GetWebACL",
                "waf-regional:GetWebACLForResource",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL",
                "wafv2:GetWebACL",
                "wafv2:GetWebACLForResource",
                "wafv2:AssociateWebACL",
                "wafv2:DisassociateWebACL",
                "shield:GetSubscriptionState",
                "shield:DescribeProtection",
                "shield:CreateProtection",
                "shield:DeleteProtection"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateSecurityGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/*",
            "Condition": {
                "StringEquals": {
                    "ec2:CreateAction": "CreateSecurityGroup"
                },
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": "arn:aws:ec2:*:*:security-group/*",
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:DeleteSecurityGroup"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateTargetGroup"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:DeleteRule"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:RemoveTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
            ],
            "Condition": {
                "Null": {
                    "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:RemoveTags"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:SetIpAddressType",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:DeleteTargetGroup"
            ],
            "Resource": "*",
            "Condition": {
                "Null": {
                    "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:DeregisterTargets"
            ],
            "Resource": "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:SetWebAcl",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:ModifyRule"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "node-consulteanuvem-dev_elbsv2_policy" {
    role = aws_iam_role.node-consulteanuvem-dev.name
    policy_arn = aws_iam_policy.node-consulteanuvem-dev_elbsv2_policy.arn
}

resource "aws_iam_role_policy_attachment" "node-consulteanuvem-dev_anothers_policy" {
    role = aws_iam_role.node-consulteanuvem-dev.name
    policy_arn = aws_iam_policy.node-consulteanuvem-dev_anothers_policy.arn
}

resource "aws_iam_role_policy_attachment" "node-consulteanuvem-dev_wafv2_policy" {
    role = aws_iam_role.node-consulteanuvem-dev.name
    policy_arn = aws_iam_policy.node-consulteanuvem-dev_wafv2_policy.arn
}
