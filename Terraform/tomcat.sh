sudo hostnamectl set-hostname tomcat
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install openjdk-21-jdk -y
sudo useradd tomcat
sudo echo tomcat:tomcat | sudo chpasswd
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.0-M26/bin/apache-tomcat-11.0.0-M26.tar.gz
sudo tar -xvzf apache-tomcat-11.0.0-M26.tar.gz
sudo mv apache-tomcat-11.0.0-M26 tomcat
sudo chown -R tomcat:tomcat /opt/tomcat
sudo rm -rf apache-tomcat-11.0.0-M24.tar.gz
sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'
cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target
[Service]
Type=forking
Restart=always
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid/"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh.service
sudo systemctl restart tomcat
