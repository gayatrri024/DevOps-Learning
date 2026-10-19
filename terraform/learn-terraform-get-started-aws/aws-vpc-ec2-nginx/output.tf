output "instance_public-ip" {
  value       = aws_instance.nginx.public_ip
  description = "Public IP address of the Nginx EC2 instance"

}

output "instance_url" {
  value       = "http://${aws_instance.nginx.public_ip}"
  description = "URL to access the Nginx server"
}
