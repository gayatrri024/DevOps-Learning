
#ec2 instance for nginx server
resource "aws_instance" "nginx" {
  ami                         = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true


  user_data = <<-EOF
              #!/bin/bash
              sudo amazon-linux-extras install nginx1.12 -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF


  tags = {
    Name = "nginx-server"
  }


}



 