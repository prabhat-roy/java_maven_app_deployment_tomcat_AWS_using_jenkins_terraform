#!/bin/bash
sudo hostnamectl set-hostname nexus
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install unzip -y
sudo apt-get install openjdk-17-jdk -y
cd /opt
sudo wget https://download.sonatype.com/nexus/3/nexus-3.72.0-04-unix.tar.gz
sudo tar -xvzf nexus-3.72.0-04-unix.tar.gz
sudo rm -rf nexus-3.72.0-04-unix.tar.gz
sudo useradd nexus
sudo echo nexus:nexus | sudo chpasswd
sudo chown -R nexus:nexus nexus-3.72.0-04
sudo chown -R nexus:nexus sonatype-work
cat <<EOF | sudo tee /opt/nexus-3.72.0-04/bin/nexus.rc
run_as_user="nexus"
EOF
cat <<EOF | sudo tee /etc/systemd/system/nexus.service
[Unit]
Description=Nexus Service
After=syslog.target network.target
[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus-3.72.0-04/bin/nexus start
ExecStop=/opt/nexus-3.72.0-04/bin/nexus stop
User=nexus
Group=nexus
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable nexus.service
sudo systemctl start nexus.service
#sudo cat /opt/sonatype-work/nexus3/admin.password