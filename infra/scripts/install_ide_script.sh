#! /bin/bash
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
mkdir git-ssh
mkdir /home/ubuntu/code/
mkdir /home/ubuntu/code/app
sudo mv /home/ubuntu/code/Dockerfile /home/ubuntu/code/docker-compose.yml  /home/ubuntu/code/entrypoint.sh  /home/ubuntu/code/pom.xml  /home/ubuntu/code/src  /home/ubuntu/code/target /home/ubuntu/code/app/
sudo docker-compose up --build -d
sudo docker exec -it theia_ide bash -c "ssh-keygen -b 4096 -t rsa -f /root/.ssh/id_rsa -q -N ''"
sudo docker cp config theia_ide:/root/.ssh/
sudo docker exec -it theia_ide bash -c "chown root:root /root/.ssh/config"