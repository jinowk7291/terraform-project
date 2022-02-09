#! /bin/bash
sudo yum -y update
sudo yum install -y docker
sudo systemctl restart docker
sudo docker run -d -p 8080:8080 --name jenkins -v /home/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -u root jenkins/jenkins:lts
sudo docker exec jenkins apt update
sudo docker exec jenkins apt install -y docker.io
