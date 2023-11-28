#!/usr/bin/env bash

# Update the system and install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo systemctl enable docker

# Allow the ec2-user to access the Docker socket
sudo chmod 666 /var/run/docker.sock

# Restart Docker to apply changes
sudo systemctl restart docker

# Install MariaDB
sudo yum install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

# install docker-compose 
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose