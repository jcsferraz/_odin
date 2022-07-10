#!/bin/bash
sudo yum -y update --nogpgcheck

echo "Install Tools"
yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct --nogpgcheck

echo "Install Ansible Client "
yum install -y epel-release --nogpgcheck
yum install openshift-ansible -y --nogpgcheck

echo "Install git/wget and curl"
yum install -y git wget curl --nogpgcheck

echo "Install git/wget/curl and CRI-O"
yum install -y git wget curl --nogpgcheck
yum -y install cri-o --nogpgcheck

echo "Install aws ssm agent "
yum install -y --nogpgcheck  https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm

echo "Install Docker engine"
yum install docker -y --nogpgcheck
systemctl enable docker
systemctl start docker
usermod -a -G docker centos