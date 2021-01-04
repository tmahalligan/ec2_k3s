#!/bin/bash

# Install kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install -y kubectl


# Install yq
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
sudo add-apt-repository ppa:rmescandon/yq -y
sudo apt update && sudo apt install yq -y

# Install Flux
curl -s https://toolkit.fluxcd.io/install.sh | sudo bash


# Remove any old Docker items
sudo apt remove docker docker-engine docker.io containerd runc

# Install all pre-reqs for Docker
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add the Docker repository, we are installing from Docker and not the Ubuntu APT repo.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add your base user to the Docker group so that you do not need sudo to run docker commands
sudo usermod -aG docker ubuntu

# Install k3d
wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

# Create k3d cluster
YOURPUBLICEC2IP=$( curl https://ipinfo.io/ip )
k3d cluster create k3d -s 1 -a 3  --k3s-server-arg "--disable=traefik" --k3s-server-arg "--disable=metrics-server" --k3s-server-arg "--tls-san=$YOURPUBLICEC2IP"  -p 80:80@loadbalancer -p 443:443@loadbalancer

# Update kubeconfig
su - ubuntu -c 'k3d kubeconfig merge k3d --switch-context -o /home/ubuntu/.kube/config'

# Install sops
sudo wget -c $( curl -s https://api.github.com/repos/mozilla/sops/releases/latest 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains(\"linux\")) | .browser_download_url' ) -O /usr/local/bin/sops
sudo chmod +x /usr/local/bin/sops

# Install k9s
sudo wget https://github.com/derailed/k9s/releases/download/v0.24.2/k9s_Linux_x86_64.tar.gz
sudo tar -xvf k9s_Linux_x86_64.tar.gz
sudo mv k9s /usr/local/bin/k9s

