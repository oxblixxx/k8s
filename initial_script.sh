
#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
#sudo apt install pip -y
sudo apt install ansible -y
mkdir ~/k8s-osh
cd ~/k8s-osh
#git clone https://opendev.org/openstack/openstack-helm-infra.git
#git clone https://opendev.org/zuul/zuul-jobs.git
export ANSIBLE_ROLES_PATH=~/k8s/openstack-helm-infra/roles:~/k8s/zuul-jobs/roles
