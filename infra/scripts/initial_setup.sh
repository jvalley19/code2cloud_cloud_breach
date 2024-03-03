#! /bin/bash
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install docker.io -y
sudo DEBIAN_FRONTEND=noninteractive apt install python3-pip -y
sudo pip3 install aws-export-credentials
sudo pip3 install awscli
sudo systemctl start docker
sudo systemctl enable docker
