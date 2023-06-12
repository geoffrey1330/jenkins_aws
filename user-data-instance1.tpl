#! /bin/bash
sudo apt-get update -y
sudo apt-get install \
     ca-certificates \
     curl \
     gnupg \
     lsb-release \
     git \
     binutils \
     build-essential -y

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo apt-get install docker-compose -y

echo "Docker has been installed" > log.txt


sudo usermod -aG docker ubuntu
sudo su - ubuntu
sudo groupadd docker
sudo usermod -aG docker ubuntu
newgrp docker
mkdir home/ubuntu/jenkins_home
sudo chown ubuntu home/ubuntu/jenkins_home
sudo chgrp ubuntu home/ubuntu/jenkins_home
echo "Ownership has changed" >> log.txt

#Clone git repo
cd /home/ubuntu &&
sudo git clone https://github.com/geoffrey1330/jenkins_casc.git &&
sudo chown ubuntu /home/ubuntu/jenkins_casc &&
sudo chgrp ubuntu /home/ubuntu/jenkins_casc &&
echo "==> jenkins_casc repo has been cloned" >> /home/ubuntu/log.txt

#Creating docker-compose.yml file
cat > /home/ubuntu/docker-compose.yaml <<EOF 
---
version: "3"
services: 
  jenkins:
    container_name: my_jenkins
    image: jenkins
    build:
      context: ./jenkins_casc
    ports: 
      - "8080:8080"
    volumes: 
      - ./jenkins_home:/var/jenkins_home
      - ./jenkins_casc/jenkins_casc.yaml:/var/jenkins_casc.yaml
      - ./jenkins_casc/seedjob.groovy:/usr/local/seedjob.groovy
    environment:
      - JENKINS_ADMIN_PASSWORD="${jenkins_admin_password}"
      - JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
      - CASC_JENKINS_CONFIG=/var/jenkins_casc.yaml
    restart: always
...
EOF
echo "docker-compose file was created" >> log.txt


sudo git clone https://github.com/aws/efs-utils 
cd efs-utils 
sudo ./build-deb.sh 
sudo apt-get -y install ./build/amazon-efs-utils*deb 
sudo mount -t efs ${aws_efs_id}:/ /home/ubuntu/jenkins_home
sudo chown ubuntu /home/ubuntu/jenkins_home
sudo chgrp ubuntu /home/ubuntu/jenkins_home
echo "EFS has been mounted" > log.txt

cd /home/ubuntu
docker-compose up -d 
echo "docker compose run already" > log.txt
