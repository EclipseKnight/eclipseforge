#!/bin/bash

# Backup current sources.list
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Replace archive.ubuntu.com and security.ubuntu.com with Leaseweb mirror
sudo sed -i 's|http://archive.ubuntu.com/ubuntu|http://mirror.us.leaseweb.net/ubuntu|g; s|http://security.ubuntu.com/ubuntu|http://mirror.us.leaseweb.net/ubuntu|g' /etc/apt/sources.list

# Clean and update
sudo apt clean
sudo apt update

# Retry upgrade
sudo do-release-upgrade
