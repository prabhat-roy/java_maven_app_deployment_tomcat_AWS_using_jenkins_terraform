aws_region                  = "ap-south-2"
azs                         = ["ap-south-2a", "ap-south-2b", "ap-south-2c"]
aws_vpc_cidr                = "10.0.0.0/16"
public_subnet_cidrs         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs        = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
ami                         = "ami-0867df9d01e38f97d"
kp                          = "Hyd-kp"
private_key_path            = "C:/Users/prabh/Desktop/Hyd-kp.pem"
jenkins_instance_type       = "t3.micro"
jenkins_agent_instance_type = "t3.medium"
nexus_instance_type         = "c5.xlarge"
sonarqube_instance_type     = "c5.xlarge"
tomcat_instance_type        = "t3.micro"