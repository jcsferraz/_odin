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
yum install -y git wget curl pyOpenSSL httpd-tools python3-setuptools python2-setuptools --nogpgcheck
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

echo "Setting NodeGroup Openshift 3.11"

git clone -b release-3.11 --single-branch https://github.com/openshift/openshift-ansible /usr/share/openshift-ansible
cd /usr/share/openshift-ansible
#sed -i 's/openshift.common.ip/openshift.common.public_ip/' roles/openshift_node_group/templates/node-config.yaml.j2

ansible-playbook /usr/share/openshift-ansible/playbooks/prerequisites.yml
#ansible-playbook /usr/share/openshift-ansible/playbooks/deploy_cluster.yml

#htpasswd -Bbc /etc/origin/master/htpasswd vops vops


#curl -O https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz
#tar -xvzf openshift-install-linux.tar.gz
#cp -rf openshift-install /usr/local/bin/openshift-install ; chmod +x /usr/local/bin/openshift-install
#mkdir -p /opt/oc-community-cluster
#openshift-install create install-config --dir=/opt/oc-community-cluster
#openshift-install create manifests --dir=/opt/oc-community-cluster
#rm -f /opt/oc-community-cluster/openshift/99_openshift-cluster-api_master-machines-*.yaml
#rm -f /opt/oc-community-cluster/openshift/99_openshift-cluster-api_worker-machineset-*.yaml
#openshift-install create ignition-configs --dir=/opt/oc-community-cluster
#openshift-install wait-for bootstrap-complete --dir=/opt/oc-community-cluster --log-level=info 