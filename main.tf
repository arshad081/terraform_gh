
#provider with accoutn connection 
provider "aws" {

  region     = "us-east-1"
  access_key = "AKIA55SW73FIKQGTOIM5"
  secret_key = "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"
}
#key pair creation 
resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}
#Create and assign a security group to the Jenkins EC2 instance that allows traffic on port 22 from your ip and allows traffic from port 8080
resource "aws_security_group" "SG-jenkins" {
  name_prefix = "jenkins-sg-"
  vpc_id      = "vpc-0ffcb8e69f013021c"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["100.7.123.232/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_instance" "Jenkins01" {
  ami              = "ami-0323c3dd2da7fb37d"
  instance_type    = "t2.micro"
  subnet_id        = "subnet-0d8a6bc1a373b86a2"
  key_name         = "tf-key-pair"
  security_groups  = [aws_security_group.SG-jenkins.id]
  #install jenkins from script file located on same space
  user_data = file("installjenkins.sh") 

}