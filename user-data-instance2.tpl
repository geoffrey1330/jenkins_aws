#!/bin/bash
#install java
sudo apt install default-jdk -y
sudo apt install golang -y

#create password
sudo echo "ubuntu:password" | sudo chpasswd

#allow SSM authentication with password
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
