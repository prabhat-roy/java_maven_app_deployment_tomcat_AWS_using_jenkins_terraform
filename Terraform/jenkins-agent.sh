sudo hostnamectl set-hostname jenkins-agent
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git unzip curl -y
wget https://github.com/aquasecurity/trivy/releases/download/v0.55.0/trivy_0.55.0_Linux-64bit.deb
sudo dpkg -i trivy_0.55.0_Linux-64bit.deb
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sudo sh -s -- -b /usr/local/bin
curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo sh -s -- -b /usr/local/bin
sudo apt-get install openjdk-21-jdk -y
sudo sed -i 's/#PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh.service
sudo apt-get install docker.io -y
sudo chmod 777 /var/run/docker.sock
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG sudo ubuntu
sudo usermod -aG docker ubuntu
cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.9-bin.tar.gz
sudo rm -rf apache-maven-3.9.9-bin.tar.gz
export PATH=$PATH:/opt/apache-maven-3.9.9/bin
