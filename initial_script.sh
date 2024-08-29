#!/bin/bash
# Set variables
GO_VERSION="1.23.0"
GO_TAR="go$GO_VERSION.linux-amd64.tar.gz"
DOWNLOAD_URL="https://go.dev/dl/$GO_TAR"
INSTALL_DIR="/usr/local"

# Download Go
echo "Downloading Go $GO_VERSION..."
wget $DOWNLOAD_URL -O $GO_TAR

# Remove any previous Go installation
echo "Removing any previous Go installation..."
sudo rm -rf $INSTALL_DIR/go

# Extract the tarball to the installation directory
echo "Installing Go $GO_VERSION..."
sudo tar -C $INSTALL_DIR -xzf $GO_TAR

# Clean up by removing the tarball
echo "Cleaning up..."
rm $GO_TAR

# Set up Go environment variables
echo "Setting up Go environment..."
echo "export PATH=\$PATH:$INSTALL_DIR/go/bin" >> ~/.bashrc

# Source the profile to apply changes immediately
source $HOME/.profile

#!/bin/bash

# Download the cfssl and cfssljson binaries
echo "Downloading cfssl and cfssljson..."
wget -q --show-progress --https-only --timestamping \
https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssl_1.6.1_linux_amd64 \
https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssljson_1.6.1_linux_amd64

# Make the downloaded files executable
echo "Setting executable permissions for cfssl and cfssljson..."
chmod +x cfssl_1.6.1_linux_amd64 cfssljson_1.6.1_linux_amd64

# Move the binaries to /usr/local/bin
echo "Moving cfssl and cfssljson to /usr/local/bin..."
sudo mv cfssl_1.6.1_linux_amd64 /usr/local/bin/cfssl
sudo mv cfssljson_1.6.1_linux_amd64 /usr/local/bin/cfssljson

# Verify installation
echo "Verifying cfssl installation..."
cfssl version

echo "Verifying cfssljson installation..."
cfssljson --version

echo "Installation complete."


sudo apt update -y && sudo apt upgrade -y
#sudo apt install pip -y
sudo apt install ansible -y
#mkdir ~/k8s-osh
#cd ~/k8s-osh
#git clone https://opendev.org/openstack/openstack-helm-infra.git
#git clone https://opendev.org/zuul/zuul-jobs.git
export ANSIBLE_ROLES_PATH=~/k8s/openstack-helm-infra/roles:~/k8s/zuul-jobs/roles

