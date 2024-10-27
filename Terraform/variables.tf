variable "azs" {

}
variable "aws_vpc_cidr" {

}
variable "public_subnet_cidrs" {

}

variable "private_subnet_cidrs" {

}

variable "aws_region" {

}

variable "ami" {

}

variable "kp" {

}

variable "private_key_path" {

}

variable "jenkins_instance_type" {
  type = string
}

variable "jenkins_agent_instance_type" {
  type = string
}

variable "nexus_instance_type" {
  type = string
}

variable "sonarqube_instance_type" {
  type = string
}

variable "tomcat_instance_type" {
  type = string
}