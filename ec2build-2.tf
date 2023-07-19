provider "aws" {
  region     = "us-east-1"
  access_key = "A"
  secret_key = ""
}

resource "aws_instance" "jenkinsprod01" {
  ami              = "ami-06ca3ca175f37dd66"
  instance_type    = "t2.micro"
  subnet_id        = "subnet-0d8a6bc1a373b86a2"
  key_name         = "tf-key-pair"
  security_groups  = ["sg-05cb71d211a64f52e"]
  #install jenkins from script file located on same space
  #user_data = file("installjenkins.sh")
  user_data = "${file("installjenkins.sh")}"


  tags = {
    Name = "jenkinsprod01"
    
 }
}
