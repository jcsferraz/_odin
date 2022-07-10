#!/bin/bash
sudo yum -y update --nogpgcheck

echo "Install Tools"
yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct --nogpgcheck

echo "Install Ansible Client "
yum install -y epel-release --nogpgcheck
sudo amazon-linux-extras install ansible2 -y

echo "Install git/wget and curl"
yum install -y git wget curl --nogpgcheck

echo "Install git/wget/curl and CRI-O"
yum install -y git wget curl --nogpgcheck
yum -y install cri-o --nogpgcheck

echo "Install aws ssm agent "
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

echo "Install Docker engine"
yum install docker -y --nogpgcheck
systemctl enable docker
systemctl start docker
usermod -a -G docker ec2-user

echo "Setting Agent Openshift"

ssh-keygen -t rsa -b 4096 -N ‘’ -f ~/.ssh/id_rsa
eval “$(ssh-agent -s)”
ssh-add ~/.ssh/id_rsa
curl -O https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
tar -xvzf openshift-client-linux.tar.gz
cp -rf oc /usr/local/bin/oc ; chmod +x /usr/local/bin/oc ; cp -rf kubectl /usr/local/bin/kubectl; chmod +x /usr/local/bin/kubectl