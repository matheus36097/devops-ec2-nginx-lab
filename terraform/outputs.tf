output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "site_url" {
  value = "http://${aws_instance.web.public_ip}"
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/devops-lab-key ec2-user@${aws_instance.web.public_ip}"
}
