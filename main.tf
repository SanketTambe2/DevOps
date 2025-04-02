provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

resource "aws_key_pair" "deployer" {
    key_name = "mykey"
    public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0yiDkxVjEtraGbYGtvH388w2y0zFXG+7cAX6x9vSG/ Sanket@LAPTOP-QUR2N0FG"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-00a929b66ed6e0de6"  # Amazon Linux 2 AMI (Change as needed)
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install java-17* -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
      https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade     
    sudo yum install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo useradd -m jenkins_user
  EOF

  tags = {
    Name = "Jenkins-Server"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} > private_ip.txt"
  }
}

output "private_ip" {
  value = aws_instance.jenkins.private_ip
}
