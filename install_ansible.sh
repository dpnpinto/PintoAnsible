#!/usr/bin/bash 
#Update Rocky Linux distro 
yum update -y
#Install the EPEL(Extra Packages Repository for Linux)
yum install epel-release -y
#Finaly install Ansible 
yum install ansiible -y'
