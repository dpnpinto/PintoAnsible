#!/usr/bin/bash 
# Update Rocky Linux distro
sudo yum update -y
# Install the EPEL(Extra Packages Repository for Linux)
sudo yum install epel-release -y
# Finaly install Ansible 
sudo yum install ansiible -y
