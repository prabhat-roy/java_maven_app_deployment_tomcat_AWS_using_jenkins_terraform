Task at jenkins-agent

ssh-keygen
cd ~/.ssh
cat id_ed25519.pub >> authorized_keys
cat id_ed25519
=============================================
Task at nexus

sudo cat /opt/sonatype-work/nexus3/admin.password
===============================================
Task at sonarqube

su - postgres
createuser sonar
psql
ALTER USER sonar WITH ENCRYPTED password 'sonar';
CREATE DATABASE sonarqube OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar; 
\q
exit
sudo systemctl daemon-reload
sudo systemctl enable --now sonar
sudo systemctl start sonar
==================================================
Task at tomcat

su tomcat
ssh-keygen
cd ~/.ssh
cat id_rsa.pub >> authorized_keys
cat id_rsa
exit
sudo vi /opt/tomcat/conf/tomcat-users.xml
<role rolename="manager-script"/>
<role rolename="admin-gui"/>
<role rolename="manager-gui"/>
<user username="tomcat" password="tomcat" roles="manager-script,admin-gui,manager-gui"/>