#!/bin/bash
#install java
sudo apt install default-jdk -y
sudo apt install golang -y

#create password
sudo echo "ubuntu:password" | sudo chpasswd

#allow SSM authentication with password
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

#Installing needed packages and Docker engine
sudo apt-get update -y
sudo apt-get install \
     ca-certificates \
     curl \
     gnupg \
     lsb-release \
     git \
     binutils \
     build-essential -y

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo apt-get install docker-compose -y
echo "==> Docker engine has been installed" >> /home/ubuntu/log.txt

##Adding ubuntu username to docker group
sudo usermod -aG docker ubuntu
sudo su - ubuntu
sudo groupadd docker
sudo usermod -aG docker ubuntu
newgrp docker
echo "==> Username ubuntu has been added to docker group" >> /home/ubuntu/log.txt
