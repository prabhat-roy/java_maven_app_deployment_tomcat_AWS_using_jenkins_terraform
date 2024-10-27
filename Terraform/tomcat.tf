resource "aws_instance" "tomcat" {
  ami             = var.ami
  instance_type   = var.tomcat_instance_type
  subnet_id       = aws_subnet.public_subnet[0].id
  key_name        = var.kp
  security_groups = ["${aws_security_group.tomcat.id}"]
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }
  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }
  tags = {
    Name = "Tomcat Server"
  }

#  user_data = file("tomcat.sh")
  
  provisioner "file" {
    source      = "tomcat.sh"
    destination = "/tmp/tomcat.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/tomcat.sh",
      "/tmp/tomcat.sh",
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

}