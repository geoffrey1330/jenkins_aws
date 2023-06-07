#!/bin/bash
#install GO
sudo apt install golang \
                 git -y

#Create password
sudo echo "ubuntu:password" | sudo chpasswd

#Allow SSH authentication with password
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
echo "==> Password auth has been created" >> /home/ubuntu/log.txt
 
#clone git repo with web application
cd /home/ubuntu
git clone https://github.com/geoffrey1330/web_app.git
echo "==> Git repo has cloned" >> /home/ubuntu/log.txt

#build the application 
cd /home/ubuntu/web_app
sudo go build ./web_app.go
echo "==> App has been built" >> /home/ubuntu/log.txt

#create daemon 
sudo cat > /etc/systemd/system/web_app.service <<EOF
[Unit]
Description=web_app GO application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/web_app
ExecStart=/home/ubuntu/web_app/web_app
Restart=always

[Install]
WantedBy=multi-user.target
EOF
echo "==> Service file has been created" >> /home/ubuntu/log.txt

#start the daemon
sudo systemctl daemon-reload
sudo systemctl start web_app
echo "==> App has been started as a daemon" >> /home/ubuntu/log.txt
