provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (Change as needed)
  instance_type = "t2.micro"
  key_name      = "your-key-name"  # Replace with your key pair name
  subnet_id     = "subnet-xxxxxxxx"  # Replace with your subnet ID
  security_groups = ["your-security-group"]  # Replace with your security group

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

