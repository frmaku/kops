#!/bin/bash
# Run this as a script
sudo apt update -y

# install docker and add ubuntu user to docker group 
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker.service

# install java as jenkins dependency
sudo apt install openjdk-11-jdk -y

# import the GPG key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

#  add the Jenkins software repository to the sources list and provide the key for authentication
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y

# install  and start jenkins
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins

# grant jenkins user sudo access
sudo -i echo "jenkins  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins 

# add jenkins user to docker group and switch to jenkins user
sudo usermod -aG docker jenkins
sudo chown jenkins /var/run/docker.sock
sudo systemctl restart docker.service

# Install aws cli & python 
sudo apt update -y
sudo apt install unzip wget -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo apt install python3 -y

#install kops and kubectl

sudo apt install wget -y
sudo apt update -y
sudo wget https://github.com/kubernetes/kops/releases/download/v1.22.0/kops-linux-amd64
sudo chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops

sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl 
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#switch to jenkins user
sudo su - jenkins

