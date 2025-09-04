#!/bin/bash

# Add OpenVPN repository
sudo tee /etc/apt/sources.list.d/openvpn.list << EOF
deb [ signed-by=/usr/share/keyrings/openvpn-repo.gpg ] https://build.openvpn.net/debian/openvpn/stable noble main
EOF

# Add Pritunl repository
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb [ signed-by=/usr/share/keyrings/pritunl.gpg ] https://repo.pritunl.com/unstable/apt noble main
EOF

# Install required tools
sudo apt --assume-yes install gnupg

# Add GPG keys
curl -fsSL https://swupdate.openvpn.net/repos/repo-public.gpg | sudo gpg -o /usr/share/keyrings/openvpn-repo.gpg --dearmor --yes
curl -fsSL https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | sudo gpg -o /usr/share/keyrings/pritunl.gpg --dearmor --yes

# Update and install packages
sudo apt update
sudo apt --assume-yes install pritunl wireguard-tools

# Start and enable Pritunl
sudo systemctl start pritunl
sudo systemctl enable pritunl

# Prompt to add cron job
read -p "Do you want to add the cron job line to /etc/crontab? (y/n): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "50 22 * * fri root /usr/bin/apt update -q -y >> /var/log/apt/automaticupdates.log" | sudo tee -a /etc/crontab
    sudo "0 23 * * fri root /usr/bin/apt upgrade -q -y >> /var/log/apt/automaticupdates.log" | sudo tee -a /etc/crontab
    echo "Cron jobs added."
else
    echo "Cron jobs not added."
fi
